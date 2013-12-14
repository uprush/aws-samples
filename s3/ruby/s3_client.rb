#!/usr/bin/env ruby
require 'aws'

AWS.config({
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :region => ENV['AWS_REGION']
})

s3 = AWS::S3.new

bucket = s3.buckets['your-bucket']
obj = bucket.objects['key']
obj.write(Pathname.new('/path/to/file.txt'))

obj.read do |chunk|
  puts chunk
  #=> data of s3://your-bucket/key
end
