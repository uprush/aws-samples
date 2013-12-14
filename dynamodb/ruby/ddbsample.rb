#!/usr/bin/env ruby

require 'aws'
require 'pp'

AWS.config({
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :region => ENV['AWS_REGION']
})

TABLE_NAME = 'my-table'

ddb = AWS::DynamoDB::Client.new(
  # :end_point => "http://localhost:8000"
  # :access_key_id => "foo",
  # :secret_access_key => "bar"
)

def create_table
  ddb.create_table(
    :table_name  => TABLE_NAME,
    :key_schema  => {
      :hash_key_element => {
        :attribute_name => 'key',
        :attribute_type => 'S'
      },
      :range_key_element => {
        :attribute_name => 'version',
        :attribute_type => 'S'
      }
    },
    :provisioned_throughput => {
      :read_capacity_units => 100,
      :write_capacity_units => 100
  }
)

end

def populate_data
  batch = AWS::DynamoDB::BatchWrite.new
  items = []
  (0..999).each do |n|
    items << {
      "key" => "myPhoto#{n}",
      "version" => "1234#{n}",
      "photographer" => "someone"
    }

    if n % 25 == 0
      batch.put(TABLE_NAME, items)
      batch.process!
      items.clear
    end
  end
  unless items.empty?
    batch.put(TABLE_NAME, items)
    batch.process!
    items.clear
  end
end

def query
  options = {
    :table_name => TABLE_NAME,
    :consistent_read => true,
    :hash_key_value => {
      :s => "myPhoto467"
    }
  }
  response = ddb.query(options)
  pp response.data
end

def scan
  options = {
    :table_name => TABLE_NAME,
    :limit => 100,
    :exclusive_start_key => {
      :hash_key_element => {
        :s => "myPhoto1"
      }
    }
  }
  response = ddb.query(options)
  pp response.data
end


# pp ddb.describe_table(:table_name => 'my-table')
populate_data

query

# sleep 1 while table.status == :creating
# table.status #=> :active

# # get an existing table by name and specify its hash key
# table = ddb.tables['another-table']
# table.hash_key = [:id, :number]

# # add an item
# item = table.items.create('id' => 12345, 'foo' => 'bar')

# # add attributes to an item
# item.attributes.add 'category' => %w(demo), 'tags' => %w(sample item)

# # update an item with mixed add, delete, update
# item.attributes.update do |u|
#   u.add 'colors' => %w(red)
#   u.set 'category' => 'demo-category'
#   u.delete 'foo'
# end
