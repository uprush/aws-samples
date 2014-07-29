#!/usr/bin/env ruby

require 'dalli-elasticache'
require 'pp'

config_endpoint = "mmfoo.t1wsve.cfg.usw2.cache.amazonaws.com:11211"

# Options for configuring the Dalli::Client
dalli_options = {
  :expires_in => 24 * 60 * 60,
  :namespace => "my_app",
  :compress => true
}

ec = Dalli::ElastiCache.new(config_endpoint, dalli_options)
client = ec.client

(0..100).each do |n|
  client.set("foo#{n}", "bar#{n}")
  puts client.get("foo#{n}")
end

