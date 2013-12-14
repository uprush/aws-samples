#!/usr/bin/env ruby
require 'aws'
require 'pp'

AWS.config({
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :region => ENV['AWS_REGION']
})

client = AWS::DynamoDB::Client.new

result = client.put_item({
  :table_name => 'my_table',
  :item => {
    'id'        => {:n => '100'},
    'timestamp' => {:n => '130699342'},
    'message'   => {:s => 'Good Morning'}
  }
})
pp result
#=> {"ConsumedCapacityUnits"=>1.0}


result = client.get_item({
  :consistent_read => true,
  :table_name => 'my_table',
  :key => {
    :hash_key_element => {:n => '100'},
    :range_key_element => {:n => '130699342'}
  }
})
pp result
#=> {"Item"=>{"id"=>{"N"=>"100"}, "message"=>{"S"=>"Good Morning"}, "timestamp"=>{"N"=>"130699342"}}, "ConsumedCapacityUnits"=>1.0}
