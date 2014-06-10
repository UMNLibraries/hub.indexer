require 'aws-sdk'

class Bucket
  attr_reader :bucket
  attr_accessor :limit
  attr_accessor :marker

  def initialize
    config = APP_CONFIG['remote_storage']
    s3 = AWS::S3.new(
      :access_key_id => config['AWS_ACCESS_KEY_ID'],
      :secret_access_key => config['AWS_SECRET_ACCESS_KEY'],
      :region => OPTS[:region]
      )
    @bucket = s3.buckets[OPTS[:bucket]]
  end

  def set_params!
    @params = {}
    @params.merge!({:limit => @limit}) if @limit
    @params.merge!({:next_token => {:marker => @marker}}) if @marker
  end

  def each
    set_params!
    @bucket.objects.each(@params) do |item|
      yield(item.key, process_s3_record(item))
    end
  end

  def process_s3_record(s3obj)
    escape_original_record(JSON.parse(s3obj.read))
  end

  def escape_original_record(record)
    record['originalRecord'] = record['originalRecord'].to_json
    record
  end
end