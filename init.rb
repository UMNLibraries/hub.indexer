require_relative "lib/hub_indexer/version"
require 'aws-sdk'
require 'yaml'
require 'open-uri'
require 'rest_client'

HubIndexer::APP_CONFIG = YAML.load_file("#{Dir.pwd}/config/hub_indexer.yml")
Dir[File.dirname(__FILE__) + "/lib/*.rb"].each {|file| require_relative file}
HubIndexer::PROFILE = YAML.load_file("#{Dir.pwd}/config/#{HubIndexer::OPTS[:profile_name]}")
