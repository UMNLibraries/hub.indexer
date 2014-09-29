require 'rsolr'

module HubIndexer
  class Indexer
    def initialize(opts)
      @solr = RSolr.connect :url => opts.fetch(:solr_url)
      @batch_id = opts.fetch(:batch_id)
      delete_batch_from_index(batch_id) if opts.fetch(:delete_batch, false)
      drop_entire_index if opts.fetch(:drop_index, false)
    end

    def delete_batch_from_index(batch_id)
      @solr.delete_by_query "batch_id_s:#{batch_id}"
    end

    def add(records)
      @solr.add records
    end

    def commit
      @solr.commit
    end

    def optimize
      @solr.optimize
    end

    def drop_entire_index
      @solr.delete_by_query "*:*"
    end
  end
end