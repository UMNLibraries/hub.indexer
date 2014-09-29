require_relative '../init.rb'

module HubIndexer
  class Runner
    def initialize(options, profile)
      @originals  = fetch_originals(options)
      @indexer    = indexer(options)
      @profile    = profile
      @push_count = options[:solr_push_count]
      @is_test    = options[:test]
    end

    def fetch_originals(opts)
      if opts[:bucket]
        return Bucket.new(opts)
      elsif opts[:directory]
        return LocalRecords.new(opts)
      else
        raise "Must specify either a bucket or local file directory option"
      end
    end

    def run
      i = 1
      records = []
      @originals.each do |key, original|
        puts "#{i} - Fetching item: #{key}"
        original['id'] = key
        records << original
        records = push_batch(records, records.count == @push_count)
        i = i + 1
      end
      puts "Indexing #{records.count} remaining records."
      push_batch records, true
      @indexer.commit
    end

    def indexer(opts)
      Indexer.new(opts)
    end

    def transform(records)
      transformer = Transformer.new(@profile)
      transformation = JSON.parse(transformer.post(records))
      transformation['records'].map { |record| record['batch_id_s'] = @batch_id }
      transformation['records'].map { |record| record.delete('originalRecord') }
      write_transformations(transformation) if @is_test
      transformation['records']
    end

    def write_transformations(transformation)
      name = Digest::MD5.hexdigest transformation.to_s
      path = File.expand_path("../../transformed/#{name}.json", __FILE__)
      File.open(path, 'w') { |file| file.write(JSON.pretty_generate(transformation)) }
    end

    def push(records)
      puts "Transforming #{records.count} records"
      transformed = transform(records)
      puts "Adding transformed records to index" unless @is_test
      response = @indexer.add transformed unless @is_test
    end

    def push_batch(records, push_now = true)
      if push_now
        push(records)
        records = []
      end
      records
    end
  end
end
