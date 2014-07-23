class LocalRecords
  def initialize(dir)
    @dir = dir
  end

  def each
    Dir.glob("#{@dir}/*.json") do |filepath|
      file = File.open(filepath, 'r')
      yield(id(filepath), process_record(file.read))
    end
  end

  def id(path)
    File.basename(path).gsub(/\.json/, '')
  end

  def process_record(record)
    escape_original_record(JSON.parse(record))
  end

  def escape_original_record(record)
    record['originalRecord'] = record['originalRecord'].to_json
    record
  end
end