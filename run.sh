#!/usr/bin/env ruby
require './init.rb'

bucket = Bucket.new
records = []
bucket.limit  = OPTS[:limit]
bucket.marker = OPTS[:marker]
i = 1
indexer = Indexer.new(APP_CONFIG['solr_url'], OPTS[:bucket], OPTS[:delete_bucket], OPTS[:drop_index], OPTS[:test])
bucket.each do |key, item|
  puts "#{i} - Fetching S3 item: #{key}"
  item['id'] = key
  records << item
  records = indexer.push_batch records, records.count == 1000
  i = i + 1
end
puts "Indexing #{records.count} remaining records."
indexer.push_batch records
indexer.commit


