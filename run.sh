#!/usr/bin/env ruby
require_relative './lib/hub_indexer.rb'

start_time = Time.now

indexer = HubIndexer::Runner.new(HubIndexer::OPTS, HubIndexer::PROFILE)

indexer.before_transform do |records|
  puts "Transforming #{records.count} records"
end

indexer.before_index do |records|
  puts "Adding transformed records to index"
end

indexer.fetch_listener do |delta, key|
  puts "#{delta} - Fetching item: #{key}"
end

indexer.run

elapsed = Time.now - start_time
puts "Elapsed time: #{elapsed}"
