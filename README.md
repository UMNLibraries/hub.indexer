
## About

The DPLA Hub Indexer is a simple script that allows you to index S3 buckets using a running instance of the [dpla.services](https://github.com/UMNLibraries/dpla.services) application.

To obtain a dpla.services api key, issue the following request:

`curl -d "api_key[email]=<your email here>@foo.com" http://hub-services.lib.umn.edu/api-key/`

## Installation

### Download the project

```
git clone git@github.com:UMNLibraries/dpla.hub.indexer.git
cd dpla.hub.indexer
chmod +x run.sh
```

### Configure the indexer

`vim config/config.yml`


```
production:
  remote_storage:
    AWS_ACCESS_KEY_ID: "<key here>"
    AWS_SECRET_ACCESS_KEY: "<key here>"
    AWS_REGION: "us-west-2"
  solr_url: "http://localhost:8983/solr"
  transformer:
    api_key: "<key here>"
    base_url: "http://hub-services.lib.umn.edu/api/v1/transform"
```
__Note__: S3 Configuration is optional. It is also possible to index from local files (see below).


### Test the transformation profile

`./run.sh --directory /directory/to/your/json/files -l 5 --batch_id some.name.here -t true`

The above command will load five DPLA JSON-LD records from your local file system, submit them along with to the http://hub-services.lib.umn.edu transformer gateway along with the transformation rules located in the  `./profile/profile.json` file and then output them as solr docs) into a file in the `./transformed` directory of this repository. This way, you can see exactly what is being set to your solr instance.

## Usage Examples

Index all records in a bucket:

`./run.sh -b dpla.hub.your.bucket.here`

Index all records from a local directory:

`./run.sh --directory /directory/to/your/json/files --batch_id some.name.here -t true`

Limit indexing to 10000 records in a bucket

`./run.sh  -l 10000 -b dpla.hub.your.bucket.here`

Limit indexing to 10000 records in a bucket beginning after the record named "`00051c04a23f9b6e89fcc9063966b6ea`"

`./run.sh  -l 10000 -m 00051c04a23f9b6e89fcc9063966b6ea`

