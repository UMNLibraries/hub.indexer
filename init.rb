require 'aws-sdk'
require 'yaml'
require 'open-uri'
require 'rest_client'

ENVIRONMENT = (ENV['DHUB_INDEXER_ENV']) ? ENV['DHUB_INDEXER_ENV'] : 'development'
APP_CONFIG = YAML.load_file("config/config.yml")[ENVIRONMENT]
require './lib/options.rb'
PROFILE = YAML.load_file("profiles/#{OPTS[:profile_name]}")

require './lib/bucket.rb'
require './lib/indexer.rb'
require './lib/transformer.rb'

