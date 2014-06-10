
## About

The DPLA Hub Indexer is a simple script that allows you to index S3 buckets using a running instance of the [dpla.services](https://github.com/UMNLibraries/dpla.services) application. 

## Installation


### Download the project

```
git clone git@github.com:UMNLibraries/dpla.hub.indexer.git
cd dpla.hub.indexer
chmod +x run.sh
```

#### Configure and test the transformation profile

_(sorry, profile creation is still undocumented)_

```
cp config/example.profile.json config/profile.json
vim config/profile.json
```

### Test the transformation profile

`./run.sh  -l 5 -b dpla.hub.your.bucket.here -t true`

The above command will transform five records (from the specified bucket that contains records in the DPLA
JSON-LD format) and then output them following the rules established in your profile.json file (e.g. transformed
into Blacklight-compliant solr docs).

## Usage Examples

Index all records in a bucket:

`./run.sh -b dpla.hub.your.bucket.here`

Limit indexing to 10000 records in a bucket

`./run.sh  -l 10000 -b dpla.hub.your.bucket.here`

Limit indexing to 10000 records in a bucket beginning after the record named "`00051c04a23f9b6e89fcc9063966b6ea`"

`./run.sh  -l 10000 -m 00051c04a23f9b6e89fcc9063966b6ea`
  
