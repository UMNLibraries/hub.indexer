require 'aws-sdk'

class Bucket
  attr_reader :bucket
  attr_accessor :limit
  attr_accessor :marker

  def initialize(params)
    @params = params
    config = APP_CONFIG['remote_storage']
    s3 = AWS::S3.new(
      :access_key_id => config['AWS_ACCESS_KEY_ID'],
      :secret_access_key => config['AWS_SECRET_ACCESS_KEY'],
      :region => @params.region
      )
    @bucket = s3.buckets[@params.bucket]
  end

  def s3_params
    s3_params = {}
    s3_params[:limit] = @params.limit if @params.limit
    s3_params[:next_token] = {:marker => @params.marker} if @params.marker
    s3_params
  end

  def each
    @bucket.objects.each(s3_params) do |item|
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