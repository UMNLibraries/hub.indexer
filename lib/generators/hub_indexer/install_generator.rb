module HubIndexer
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc "This generator copies a hub_indexer config files and sample records to your Rails project"
    def copy_config
      copy_file "hub_indexer.yml", File.join("config", "hub_indexer.yml")
      copy_file "hub_indexer_profile.json", File.join("config", "hub_indexer_profile.json")
      copy_file "hub_indexer.yml", File.join("config", "example.hub_indexer.yml")
      directory  "transformed", File.join("tmp", "hub_indexer", "transformed")
      directory  "records", File.join("tmp", "hub_indexer", "records")
    end
  end
end
