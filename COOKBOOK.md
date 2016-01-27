# Platform Integration Cookbook

This is a selection of useful tips for developing on platform

## Restart all base system components

### Problem

You want to restart all the services on the system

### Solution

Restart the base systemd unit that all other services are depending on. This will trigger systemd to restart the
full stack.

    sudo systemctl restart init-protonet

## Build a docker image directly on the box

### Problem

For quick turnaround time while developing integration of your software with docker and platform you want to skip the
process of building a Docker image from a source code repository via a Continuous Integration system, then uploading it
into a docker registry and finally downloading the image to verify it works

### Solution

Instead of going through the your whole automated build process you can also just build the corresponding docker image 
directly on the box. Note that this is only recommended for development, for producing production images you should have
an automated CI system set up.

    ssh -A core@boxname.local
    # git clone or scp
    docker build -t org/repo:tag .
    # restart required services