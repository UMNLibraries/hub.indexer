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
  opts.on("-x", "--batch_id [BATCH_ID]", "The batch identifier (used to selectively delete batches of records).") do |batch_id|
    options[:batch_id] = batch_id
  end
  opts.on("-b", "--bucket [BUCKET]", "The s3 bucket to index.") do |bucket|
    options[:bucket] = bucket
  end
  opts.on("-y", "--directory [DIRECTORY]", "A directory that contains individual json records for indexing.") do |directory|
    options[:directory] = directory
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
  opts.on("-d", "--delete-batch", "Delete the records for a given batch identifier (e.g. a bucket name).") do |delete_batch|
    options[:delete_batch] = delete_batch
  end
  opts.on("-i", "--drop-index", "CAREFUL! Drop the whole solr index.") do |drop_index|
    options[:drop_index] = drop_index
  end
  opts.on("-s", "--solr-url [SOLR_URL]", "The URL of the solr instance.") do |solr_url|
    options[:solr_url] = solr_url
  end
  opts.on("-u", "--solr-push-count [SOLR_PUSH_COUNT]", "The the number of records to push to solr at one time.") do |solr_push_count|
    options[:solr_push_count] = solr_push_count
  end
end.parse!
# Always use the bucket ID as the batch ID, unless otherwise directed
options[:batch_id] = (options[:bucket] && !options[:batch_id]) ? options[:bucket] : options[:batch_id]
options[:region] = (options[:region]) ? options[:region] : APP_CONFIG['remote_storage']['AWS_REGION']
options[:solr_url] = (options[:solr_url]) ? options[:solr_url] : APP_CONFIG['solr_url']
options[:solr_push_count] = (options[:solr_push_count].to_i) ? options[:solr_push_count] : 1000
options[:profile_name] = (options[:profile_name]) ? options[:profile_name] : 'profile.json'
OPTS = options