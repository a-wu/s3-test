#!/usr/bin/env ruby
require 'aws-sdk'
require 'yaml'

(bucket_name, file_name) = ARGV
unless bucket_name && file_name
  puts "Usage: upload_file.rb <BUCKET_NAME> <FILE_NAME>"
  exit 1
end

config_path = File.expand_path( "../config/config.yaml", __FILE__ )



AWS.config(YAML.load_file(config_path))


# get an instance of the S3 interface using the default configuration
s3 = AWS::S3.new

# create a bucket
b = s3.buckets.create(bucket_name)

# upload a file
basename = File.basename(file_name)
o = b.objects[basename]
o.write(:file => file_name)

puts "Uploaded #{file_name} to:"
puts o.public_url

# generate a presigned URL
puts "\nUse this URL to download the file:"
puts o.url_for(:read)

puts "(press any key to delete the object)"
$stdin.getc

o.delete