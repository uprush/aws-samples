#!/usr/bin/env ruby

require 'dalli'
require 'pp'

config_endpoint = "mmfoo.t1wsve.0001.usw2.cache.amazonaws.com:11211"

# Options for configuring the Dalli::Client
dalli_options = {
  :expires_in => 24 * 60 * 60,
  :namespace => "my_app",
  :compress => true
}

client = Dalli::Client.new(config_endpoint, dalli_options)

(0..100).each do |n|
  puts client.get("foo#{n}")
end

