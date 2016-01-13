# Platform Integration - Logstash example

This example application builds a custom logstash image that consumes an RSS feed, stores it in elasticsearch that we can
later browse using Kibana.

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