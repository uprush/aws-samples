require 'yaml'
require_relative 'basic_activity.rb'

# **SubscribeTopicActivity** sends an SMS / email message to the user, asking for
# confirmation.  When this action has been taken, the activity is complete.
class SubscribeTopicActivity < BasicActivity

  def initialize
   super('subscribe_topic_activity')
  end

  def create_topic(sns_client)
    topic_arn = sns_client.create_topic(:name => 'SWF_Sample_Topic')[:topic_arn]

    if topic_arn
      sns_client.set_topic_attributes({
        :topic_arn => topic_arn,
        :attribute_name => 'DisplayName', # only required for sending SMS messages with SNS
        :attribute_value => 'SWFSample'
        })

    else
      @results = {
        :reason => "Couldn't create SNS topic", :detail => ""
      }.to_yaml
    end

    return topic_arn
  end

  def do_activity(task)
    activity_data = {
      :topic_arn => nil,
      :email => { :endpoint => nil, :subscription_arn => nil },
      :sms => { :endpoint => nil, :subscription_arn => nil }
    }

    if task.input
      input = YAML.load(task.input)
      activity_data[:email][:endpoint] = input[:email]
      activity_data[:sms][:endpoint] = input[:sms]
    else
      @results = { :reason => "Didn't receive any input!", :detail => "" }.to_yaml
      puts("  #{@results.inspect}")
      return false
    end

    # Create an SNS client. This is used to interact with the service.
    # region to $SNS_REGION, which is a region that specified in the config.yml file
    # (defined in the file `swf_sns_utils.rb`).
    sns_client = AWS::SNS::Client.new(
         :config => AWS.config.with(:region => $SNS_REGION))

    # Create the topic and get the ARN
    activity_data[:topic_arn] = create_topic(sns_client)

    return false unless activity_data[:topic_arn]

    # Subscribe the user to the topic, using either or both endpoints.
    [:email, :sms].each do |x|
      ep = activity_data[x][:endpoint]
      # don't try to subscribe an empty endpoint
      if ep != nil && ep != ""
        response = sns_client.subscribe({
          :topic_arn => activity_data[:topic_arn],
          :protocol => x.to_s,
          :endpoint => ep
          })

        activity_data[x][:subscription_arn] = response[:subscription_arn]
      end
    end

    # if at least one subscription arn is set, consider this a success.
    if (activity_data[:email][:subscription_arn] != nil) or (activity_data[:sms][:subscription_arn] != nil)
      @results = activity_data.to_yaml
    else
      @results = { :reason => "Couldn't subscribe to SNS topic", :detail => "" }.to_yaml
      puts("  #{@results.inspect}")
      return false
    end

    return true
  end

end