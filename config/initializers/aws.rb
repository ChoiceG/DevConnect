require 'aws-sdk-s3'

Aws.config.update({
  region: 'eu-north-1',
  credentials: Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'], 
    ENV['AWS_SECRET_ACCESS_KEY']
  )
})
