#!/usr/bin/env ruby
require 'aws'
require 'pp'

AWS.config({
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :region => ENV['AWS_REGION']
})

sqs = AWS::SQS.new

queue_url = 'https://sqs.us-west-2.amazonaws.com/xxxxx/your_queue'
result = sqs.client.send_message({
  :queue_url    => queue_url,
  :message_body => 'Send Message!'
})
pp result

result = sqs.client.receive_message({
  :queue_url    => queue_url
})
pp result
