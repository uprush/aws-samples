require 'yaml'
require_relative 'basic_activity.rb'

# **WaitForConfirmationActivity** waits for the user to confirm the SNS
# subscription.  When this action has been taken, the activity is complete. It
# might also time out...
class WaitForConfirmationActivity < BasicActivity

  # Initialize the class
  def initialize
   super('wait_for_confirmation_activity')
  end


  def do_activity(task)
    if task.input.nil?
      @results = { :reason => "Didn't receive any input!", :detail => "" }.to_yaml
      return false
    end

    subscription_data = YAML.load(task.input)
    topic = AWS::SNS::Topic.new(subscription_data[:topic_arn])

    if topic.nil?
      @results = {
        :reason => "Couldn't get SWF topic ARN",
        :detail => "Topic ARN: #{topic.arn}"
      }.to_yaml
      return false
    end

    # loop until we get some indication that a subscription was confirmed.
    subscription_confirmed = false
    while !subscription_confirmed
      topic.subscriptions.each do |sub|
        if subscription_data[sub.protocol.to_sym][:endpoint] == sub.endpoint
          # this is one of the endpoints we're interested in. Is it subscribed?
          if sub.arn != 'PendingConfirmation'
            subscription_data[sub.protocol.to_sym][:subscription_arn] = sub.arn
            puts "Topic subscription confirmed for (#{sub.protocol}: #{sub.endpoint})"
            @results = subscription_data.to_yaml
            return true
          else
            puts "Topic subscription still pending for (#{sub.protocol}: #{sub.endpoint})"
          end
        end
      end

      task.record_heartbeat!({
        :details => "#{topic.num_subscriptions_confirmed} confirmed, #{topic.num_subscriptions_pending} pending"
        })
      # sleep a bit
      sleep(4.0)
    end # while

    unless subscription_confirmed
      @results = {
        :reason => "No subscriptions could be confirmed",
        :detail => "#{topic.num_subscriptions_confirmed} confirmed, #{topic.num_subscriptions_pending} pending"
      }.to_yaml
      return false
    end
  end

end