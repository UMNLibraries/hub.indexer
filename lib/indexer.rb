require 'rsolr'

class Indexer

  def initialize(url, batch_id, delete_batch = false, drop_index = false, test = nil)
    @solr = RSolr.connect :url => url
    @batch_id = batch_id
    delete_batch_from_index(batch_id) if delete_batch
    drop_entire_index if drop_index
    @is_test = test
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

  def push(records)
    puts "Transforming #{records.count} records"
    transformed = transform(records)
    puts "Adding transformed records to index" unless @is_test
    response = add transformed unless @is_test
  end


  def transform(records)
    transformer = Transformer.new(PROFILE)
    transformation = JSON.parse(transformer.post(records))
    transformation['records'].map { |record| record['batch_id_s'] = @batch_id }
    transformation['records'].map { |record| record.delete('originalRecord') }
    write_transformations(transformation) if @is_test
    transformation['records']
  end

  def write_transformations(transformation)
    name = Digest::MD5.hexdigest transformation.to_s
    File.open("transformed/#{name}.json", 'w') { |file| file.write(JSON.pretty_generate(transformation)) }
  end

  def push_batch(records, push_now = true)
      if push_now
        push(records)
        records = []
      end
      records
  end
end