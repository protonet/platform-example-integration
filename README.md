# Docker for System Integrators

First steps leading to a local installation suitable for all tasks regarding the integration of an existing application into Protonet Platform.

## Installation

Initial requirements are  `docker`, `docker-compose` and if the development machine does run OS X instead of linux, `docker-machine`. As OS X does not support docker directly VirtualBox will be used to run a linux machine.


On Linux [docker](https://docs.docker.com/linux/step_one/) and [docker-compose](https://docs.docker.com/engine/installation/ubuntulinux/) should be readily available, on OS X the [Docker Toolbox](https://www.docker.com/docker-toolbox) installs all requirements.


## Basics

Protonet Platform provides persistent storage as file system (mounted on `/data/`), as well as multiple structured storage services (for example Elasticsearch, MySQL, and PostgreSQL).

For local development and testing these are provided by simple docker containers. Dependencies and different independent testing environment are managed using `docker-compose`.


## Initial Configuration

As an example we want to build a simple ELK stack. This consists of [Elasticsearch](https://www.elastic.co/products/elasticsearch) for structured storage, [Logstash](https://www.elastic.co/products/logstash) for data ingestion system and [Kibana](https://www.elastic.co/products/kibana) as an analytics frontend. Elasticsearch and Kibana will represent externally managed dependencies, i.e. they are just used as is. Logstash, in contrast, will be locally configured, much in the way a locally developed component would be.

All examples are selected so that minimal code is needed.

We start by providing the prepacked dependency using a minimal `docker-compose.yml`:

```yaml
kibana:
  image: kibana@4
  links:
    - elasticsearch
  ports:
    - "80:5601"
  
elasticsearch:
  image: elasticsearch@2
```

Start the composition with `docker-compose up` and Elasticsearch and Kibana will come up.

In this case we use [Elasticsearch](https://hub.docker.com/_/elasticsearch/) but [MySQL](https://hub.docker.com/_/mysql/), [PostgreSQL](https://hub.docker.com/_/postgres/) and many more are easily available.

## Adding components

In most cases products consist of one ore more components, for example a worker, a dispatcher and a web interface. We suggest to run a separate docker container for each component to ensure separation of concerns.

As these components are not available from the docker hub we need to build them ourselves:

1. create a directory for each componentent.
1. add any needed configuration files
1. create a suitable `Dockerfile`
1. Extend the docker-compose.yml

Note: Building and packaging of the software typically is usually done in a prior step (most likely by a CI) and thus not part of this readme. To understand best practice regarding building a `Dockerfile` we strongly suggest XXX

#TODO: REF DOKU
#TODO: REF EXAMPLES 

Example `Dockerfile`:


```dockerfile
FROM logstash
RUN /opt/logstash/bin/plugin install logstash-input-rss
ADD logstash.conf /logstash.conf
```

`docker-compose.yml`

```yaml
logstash:
  build: logstash
  links:
    - elasticsearch
  command: 'logstash agent -f /logstash.conf'

kibana:
  image: kibana@4
  links:
    - elasticsearch
  ports:
    - "80:5601"
  
elasticsearch:
  image: elasticsearch@2
```

Now first build the docker image with `docker-compose build` and then start the stack with `docker-compose up`. After a moment the whole stack should be running and Logstash start to index the Heise Newsticker Newsfeed.
