# Welcome to the Nsys Docker Library!

## Quick links

* [Nsys Platform][1]
* [Nsys Code][2]

## Description

The Nsys Docker Library provides set of images and maintenance scripts for development, deployment and testing of the [Nsys Platform](https://nsys.org). See [the Docker Hub page](https://hub.docker.com/r/nsys) for the full list of available Docker images for Nsys Platform and for information regarding contributing and issues.

[1]: https://nsys.org
[2]: https://code.nsys.org

# How to build Docker Images

## nsys/ubuntu

* Includes updates
* [Source code](https://github.com/nsys-code/nsys-docker-library)

### Build the Image

~~~~
$ cd baseimages/ubuntu && docker build -t nsys/ubuntu .
~~~~

### Run the Image

~~~~
$ docker run -it --rm nsys/ubuntu /bin/bash
~~~~