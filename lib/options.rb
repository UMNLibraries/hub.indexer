require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ./run.sh [options]"
  opts.on("-l", "--limit [LIMIT]", Integer, "Limit the nubmer of records retrieved.") do |limit|
    options[:limit] = limit
  end
  opts.on("-m", "--marker [MARKER]", "The name (marker) of the S3 object after which to begin indexing.") do |marker|
    options[:marker] = marker
  end
  opts.on("-b", "--bucket [BUCKET]", "The s3 bucket to index.") do |bucket|
    options[:bucket] = bucket
  end
  opts.on("-r", "--region [REGION]", "(Optionally Override the config.yml value) The s3 region where the bucket is located (e.g. us-west-2).") do |region|
    options[:region] = region
  end
  opts.on("-t", "--transform-only-verbose", "Output your transformations without sending them to the solr indexer.") do |test|
    options[:test] = test
  end
  opts.on("-p", "--profile-name [PROFILE_NAME]", "Specify which profile from the profile directory to use (e.g. -p u-of-m-profile.json).") do |profile_name|
    options[:profile_name] = profile_name
  end
  opts.on("-d", "--delete-bucket", "Delete the records for a given bucket from S3.") do |delete_bucket|
    options[:delete_bucket] = delete_bucket
  end
end.parse!
options[:region] = (options[:region]) ? options[:region] : APP_CONFIG['remote_storage']['AWS_REGION']
OPTS = options