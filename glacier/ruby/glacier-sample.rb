#!/usr/bin/env ruby

require 'aws'
require 'pp'
require 'digest'

AWS.config({
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :region => ENV['AWS_REGION']
})

glacier = AWS::Glacier.new
client = glacier.client
# pp client.list_vaults(:account_id => '-')
# pp client.list_jobs(
#     :account_id => '-',
#     :vault_name => 'yifeng'
#   )
# exit 1

# update an archive
# FILE_TO_UPLOAD = "/tmp/d-kirameki.jpg"
# checksum = Digest::SHA256.hexdigest(IO.read(FILE_TO_UPLOAD))
# puts checksum

# res = client.upload_archive(
#     :account_id => '-',
#     :vault_name => 'yifeng',
#     :checksum => checksum,
#     :body => File.open(FILE_TO_UPLOAD)
#   )
# pp res

# retrive vault inventory
# job = client.initiate_job(
#     :account_id => '-',
#     :vault_name => 'yifeng',
#     :job_parameters => {
#       :type => "inventory-retrieval",
#       :description => "retrive inventory from vault /yifeng"
#     }
#   )
# pp job

# retrive an archive
# job = client.initiate_job(
#     :account_id => '-',
#     :vault_name => 'yifeng',
#     :archive_id => 'my_archive_id'
#   )
# pp job

# # Once the job is completed, downlaod bytes
# job_id = "my_jobid"
# job_result = client.get_job_output(
#     :account_id => '-',
#     :vault_name => 'yifeng',
#     :job_id => job_id
#   )

# File.open('/tmp/myarchive.jpg', 'w') { |f| f.write(job_result.body)}

# TODO: stream bytes to file rather than store in memory
