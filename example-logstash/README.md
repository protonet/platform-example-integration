# Platform Integration - Logstash example

As an example we want to build a simple ELK stack. This consists of [Elasticsearch](https://www.elastic.co/products/elasticsearch) for structured storage, [Logstash](https://www.elastic.co/products/logstash) for data ingestion system and [Kibana](https://www.elastic.co/products/kibana) as an analytics frontend. Elasticsearch and Kibana will represent externally managed dependencies, i.e. they are just used as is. Logstash, in contrast, will be locally configured, much in the way a locally developed component would be.

The `docker-compose.yml` and `Dockerfile` include comments on what is happening.

## Running it

On your local checkout of this repository, open this directory in your terminal, then launch:

    docker-compose up

This should pull down the official images for elasticsearch and kibana from the Docker Registry and build a local image
for Logstash using the Dockerfile and logstash config contained in this repo. 

Once that is done all components should start up. You can then open http://localhost in your browser and see the Kibana web interface.
On the first screen (*Configure an index pattern*) you can confirm the defaults, then after clicking on *Discover* you should see
the latest news headlines from Heise.de pulled into your index.

## Stopping it

You can hit `ctrl+c` in your terminal to stop the running services, then you can remove the local containers:

    docker-compose rm -f