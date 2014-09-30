require_relative "lib/hub_indexer/version"
require 'aws-sdk'
require 'yaml'
require 'open-uri'
require 'rest_client'

HubIndexer::APP_CONFIG = YAML.load_file("#{Dir.pwd}/config/hub_indexer.yml")
require_relative './lib/options.rb'
HubIndexer::PROFILE = YAML.load_file("#{Dir.pwd}/config/#{HubIndexer::OPTS[:profile_name]}")

require_relative './lib/hub_indexer.rb'
require_relative './lib/local_records.rb'
require_relative './lib/bucket.rb'
require_relative './lib/indexer.rb'
require_relative './lib/transformer.rb'
