require 'aws-sdk'

# Load config file and set the options
begin
  config_file = File.open("/Users/yifengj/.aws/config.yml") { |f| f.read}
rescue Exception => e
  puts "No config file!"
end

if config_file.nil?
  options = {}
else
  options = YAML.load(config_file)
end

# SMS Messaging (which can be used by Amazon SNS) is available only in the
# `us-east-1` region.
# $SMS_REGION = 'us-east-1'
# options[:region] = $SMS_REGION

if options[:region]
  $SNS_REGION = options[:region]
else
  $SNS_REGION = 'us-west-2'
end

# Now, set the options
AWS.config(options)

# Registers the domain that the workflow will run in
DOMAIN_NAME = 'SWFSampleDomain'

def init_domain
  domain = nil
  swf = AWS::SimpleWorkflow.new

  # First, check to see if the domain already exists and is registered
  swf.domains.registered.each do |d|
    if d.name == DOMAIN_NAME
      domain = d
      break
    end
  end

  if domain.nil?
    # register the domain for one day.
    domain = swf.domains.create(
        DOMAIN_NAME,
        1,
        { :description => "#{DOMAIN_NAME} domain" }
      )
  end

  return domain
end
