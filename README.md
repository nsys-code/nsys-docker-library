# Welcome to the Nsys Docker Library!

## Quick links

* [Nsys Platform][1]
* [Nsys Code][2]

## Description

The Nsys Docker Library provides set of images and maintenance scripts for development, deployment and testing of the [Nsys Platform](https://nsys.org). See [the Docker Hub page](https://hub.docker.com/r/nsys) for the full list of available Docker images for the Nsys Platform and for information regarding contributing and issues.

[1]: https://nsys.org
[2]: https://code.nsys.org

# How to build images

## nsys/ubuntu

* Includes updates
* [Dockerfile and source code](https://github.com/nsys-code/nsys-docker-library)

### Build the Image

~~~~
$ cd baseimages/ubuntu && docker build -t nsys/ubuntu .
~~~~

### Run the Image

~~~~
$ docker run -it --rm nsys/ubuntu /bin/bash
~~~~

## nsys/debian

* Includes updates
* [Dockerfile and source code](https://github.com/nsys-code/nsys-docker-library)

### Build the Image

~~~~
$ cd baseimages/debian && docker build -t nsys/debian .
~~~~

### Run the Image

~~~~
$ docker run -it --rm nsys/debian /bin/bash
~~~~