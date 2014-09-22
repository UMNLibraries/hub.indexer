#!/usr/bin/env ruby
require_relative './init.rb'
start_time = Time.now

etl = Etl.new(OPTS, PROFILE)
etl.run

elapsed = Time.now - start_time
puts "Elapsed time: #{elapsed}"
