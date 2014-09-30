
## About

The DPLA Hub Indexer is a simple script that allows you to index records stored in S3 buckets or your local file system using a running instance of the [dpla.services](https://github.com/UMNLibraries/dpla.services) application.

### Stand-Alone Script Install with Bundler

Install the hub_indexer gem, its dependencies along with its executables:
```
mkdir hub_indexer
cd hub_indexer
echo "source 'https://rubygems.org'\n\ngem 'hub_indexer', :git => 'git@github.com:UMNLibraries/dpla.hub.indexer.git'" > Gemfile
bundle install
```

### Configure

Generate the config files used by hub_indexer:
```
hub_indexer_init
```

Get a key from [http::hub-services.lib.umn.edu](hub-services.lib.umn.edu), allowing you to use its transformation service:

`curl -d 'api_key[email]=youremail@youremail.com' hub-services.lib.umn.edu/api-key`

Paste the key returned by the above command into the transformer:

```
  vim config/config.yml
  ...
  solr_url: "http://localhost:8983/solr"
  transformer:
    api_key: "<<<<PASTE YOUR TRANFORMER KEY HERE>>>"
    base_url: "http://hub-services.lib.umn.edu/api/v1/transform"
```
__Note__: S3 Configuration is optional. It is also possible to index from local files (see below).

### Test the transformation profile

Transform and index one record (using sample records provided by the `hub_indexer_init` executable):

`bundle exec ./run.sh -l 1 --batch_id test --directory ./test_records -t true`

The above command will load 1 DPLA JSON-LD records from your local `./test_transformed` directory, submit them along with to the http://hub-services.lib.umn.edu transformer gateway along with the transformation rules located in the  `./config/profile.json` file and then output them as solr docs) into a file in the `./test_transformed` directory of this repository. This way, you can see exactly what is being set to your solr instance.

## Usage Examples

Index all records in a bucket:

`bundle exec  ./run.sh -b dpla.hub.your.bucket.here`

Index all records from a local directory:

`bundle exec  ./run.sh --directory /directory/to/your/json/files --batch_id some.name.here`

Limit indexing to 100 records in a bucket

`bundle exec ./run.sh  -l 100 -b dpla.hub.your.bucket.here`

Limit indexing to 100 records in a bucket beginning after the record named "`00051c04a23f9b6e89fcc9063966b6ea`"

`./run.sh  -l 100 -m 00051c04a23f9b6e89fcc9063966b6ea`

