require 'rsolr'

class Indexer

  def initialize(url, bucket, delete_bucket = nil, test = nil)
    @solr = RSolr.connect :url => url
    @bucket = bucket
    delete_bucket_index(bucket) if delete_bucket
    @is_test = test
  end

  def delete_bucket_index(bucket)
    @solr.delete_by_query "bucket_s:#{bucket}"
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

  def drop_index
    solr.delete_by_query "*:*"
  end

  def push(records)
    puts "Transforming #{records.count} records"
    transformed = transform(records)
    puts "Adding transformed records to index" unless @is_test
    response = add transformed unless @is_test
  end


  def transform(records)
    transformer = Transformer.new(PROFILE)
    transformation = JSON.parse(transformer.post(records))
    transformation['records'].map { |record| record.merge({'bucket_s' => @bucket}) }
    transformation['records'].map { |record| record.delete('originalRecord') }
    puts "#{JSON.pretty_generate(transformation)}" if @is_test
    transformation['records']
  end

  def push_batch(records, push_now = true)
      if push_now
        push(records)
        records = []
      end
      records
  end
end