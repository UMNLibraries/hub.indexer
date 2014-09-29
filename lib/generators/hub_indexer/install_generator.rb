module HubIndexer
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

   desc "This generator copies a hub_indexer.yml config file to your Rails config directory"

    def copy_config
      copy_file "hub_indexer.yml", "config/hub_indexer.yml"
    end
  end
end
