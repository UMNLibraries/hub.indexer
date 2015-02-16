# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hub_indexer/version'

Gem::Specification.new do |spec|
  spec.name          = "hub_indexer"
  spec.version       = HubIndexer::VERSION
  spec.authors       = ["Chad Fennell"]
  spec.email         = ["fenne035@umn.edu"]
  spec.summary       = %q{Transform (via dpla.services) json documents loaded from Amazon S3 or a local file system directory into (Blacklight compliant) solr documents and push them to solr.}
  spec.license       = "MIT"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "rsolr", '~> 1.0.10'
  spec.add_runtime_dependency "aws-sdk", '~> 1.60.2'
  spec.add_runtime_dependency "rest_client", '~> 1.7.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
