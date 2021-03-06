require 'restclient'

module HubIndexer
  class Transformer
    def initialize(profile)
      @profile = profile
    end

    def post(extraction, enrichments = nil)
      if extraction
        begin
          resource = RestClient::Resource.new(HubIndexer::APP_CONFIG['transformer']['base_url'],
            :timeout => 600,
            :open_timeout => 60,
            :content_type => :json,
            :accept => :json
          )
          records = resource.post(
              {
                :profile => @profile.to_json,
                :records => extraction.to_json,
                :enrichments => enrichments.to_json,
                :api_key => APP_CONFIG['transformer']['api_key']
              }
            )
        rescue => e
          raise e
        end
      end
    end
  end
end