#!/usr/bin/env ruby
require './init.rb'
start_time = Time.now
indexer = Indexer.new(OPTS[:solr_url], OPTS[:batch_id], OPTS[:delete_batch], OPTS[:drop_index], OPTS[:test])

if OPTS[:bucket]
  BucketParams = Struct.new(:bucket, :region, :limit, :marker)
  bucket_params = BucketParams.new(OPTS[:bucket], OPTS[:region], OPTS[:limit], OPTS[:marker])
  originals = Bucket.new(bucket_params)
end

originals = LocalRecords.new(OPTS[:directory], OPTS[:limit], OPTS[:marker]) if OPTS[:directory]
i = 1
records = []
indexer.commit
originals.each do |key, original|
  puts "#{i} - Fetching item: #{key}"
  original['id'] = key
  records << original
  records = indexer.push_batch(records, records.count == 1000)
  i = i + 1
end
puts "Indexing #{records.count} remaining records."
indexer.push_batch records, true
indexer.commit

elapsed = Time.now - start_time
puts "Elapsed time: #{elapsed}"
