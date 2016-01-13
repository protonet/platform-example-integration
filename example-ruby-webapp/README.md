# Platform Integration - Ruby Web app example

This example shows how to wrap a web application written in Ruby in a Docker container using the community-provided
[Ruby docker base image](https://hub.docker.com/_/ruby/) and hence should give you a basic overview of how to
wrap a software application in a docker image based on the existing public language stack images.

The `docker-compose.yml` and `Dockerfile` include comments on what is happening.

## What does it do?

The app directory contains an example ruby app that acts as a caching proxy: It fetches data from another HTTP
api, caching the response for 30 seconds inside redis because our remote API is slow - for the sake of this demo
we are using a special HTTP service that intentionally responds very slowly.

## Running it

On your local checkout of this repository, open this directory in your terminal, then launch:

    docker-compose up

This should build the app image, pull the redis image and launch both.

You can now `curl localhost`. The first request should take around two seconds since the response is not cached in
redis yet, subsequent requests should be screaming fast thanks to the cached response stored in our redis container.
After 30 seconds the cache expires and will be fetched from the upstream server again.

## Stopping it

You can hit `ctrl+c` in your terminal to stop the running services, then you can remove the local containers:

    docker-compose rm -f

## Development flow

Running `docker-compose build` will re-build your image as you are putting together your Dockerfile.

Once the image is built, you can also execute the unit tests for the app inside a docker container using:

    docker run -i -t --rm examplerubywebapp_app bundle exec rspec spec.rb

This can also be helpful for setting up continuous integration for your image repository. On a CI server, on each
push to your source code repository you could:

  1. Build the image using `docker build --pull -t myrepo/myapp:latest .`
  2. Run your test suite inside the container to verify it works: `docker run -i -t --rm myrepo/myapp:latest bundle exec rspec spec.rb`
  3. Push the image to your registry repo on success: `docker push myrepo/myapp:latest`