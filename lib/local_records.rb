module HubIndexer
  class LocalRecords
    def initialize(opts)
      @dir = opts.fetch(:directory)
      @limit = opts.fetch(:limit, nil)
      @marker = opts.fetch(:marker, nil)
    end

    def each
      i = 0
      Dir.glob("#{@dir}/*.json") do |filepath|
        @marked = reached_marker?(@marker, id(filepath)) if !@marked
        file = File.open(filepath, 'r')
        yield(id(filepath), process_record(file.read)) if @marked
        i = i + 1 if @marked
        break if @limit == i
      end
    end

    def reached_marker?(marker, filename)
      (filename == marker || marker.nil?) ? true : false
    end

    def id(path)
      File.basename(path, ".*")
    end

    def process_record(record)
      escape_original_record(JSON.parse(record))
    end

    def escape_original_record(record)
      record['originalRecord'] = record['originalRecord'].to_json
      record
    end
  end
end