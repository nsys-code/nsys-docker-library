# Welcome to the Nsys Docker Library!

## Quick links

* [Nsys Platform][1]
* [Nsys Code][2]
* [Nsys Installation and Configuration][3]

## Description

The Nsys Docker Library provides set of images and maintenance scripts for development, deployment and testing of the [Nsys Platform](https://nsys.org). See [the Docker Hub page](https://hub.docker.com/r/nsys) for the full list of available Docker images for the Nsys Platform and for information regarding contributing and issues.

[1]: https://nsys.org
[2]: http://code.nsys.org
[3]: http://doc.nsys.org/display/NSYS/Nsys+Installation+and+Configuration

## Nsys Platform (Nsys Portal)

~~~~
$ docker run -it --rm -p 9060:9060 nsys/nsys
~~~~

> For more details about Docker image [nsys/nsys](https://hub.docker.com/r/nsys/nsys) see [this page](nsys/README.md).

## Nsys Platform (Nsys Node)

~~~~
$ docker run -it --rm -p 9080:9080 nsys/nsys-node
~~~~

> For more details about Docker image [nsys/nsys-node](https://hub.docker.com/r/nsys/nsys-node) see [this page](nsys-node/README.md).
