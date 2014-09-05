require 'aws-sdk'
require 'yaml'
require 'open-uri'
require 'rest_client'

dir = File.dirname(__FILE__)
ENVIRONMENT = (ENV['DHUB_INDEXER_ENV']) ? ENV['DHUB_INDEXER_ENV'] : 'development'
APP_CONFIG = YAML.load_file("#{dir}/config/config.yml")[ENVIRONMENT]
require_relative './lib/options.rb'
PROFILE = YAML.load_file("#{dir}/profiles/#{OPTS[:profile_name]}")

require_relative './lib/local_records.rb'
require_relative './lib/bucket.rb'
require_relative './lib/indexer.rb'
require_relative './lib/transformer.rb'

