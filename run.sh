#!/usr/bin/env ruby
require_relative './lib/hub_indexer.rb'

start_time = Time.now

HubIndexer::Runner.new(HubIndexer::OPTS, HubIndexer::PROFILE).run

elapsed = Time.now - start_time
puts "Elapsed time: #{elapsed}"
