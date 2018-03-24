# Nsys Platform (Nsys Node)

## Quick links

* [Nsys Platform][1]
* [Nsys Code][2]
* [Nsys Installation and Configuration][3]

## Description

The Nsys Docker Library provides set of images and maintenance scripts for development, deployment, 
and testing of the [Nsys Platform](https://nsys.org). See [the Docker Hub page](https://hub.docker.com/r/nsys) 
for the full list of available Docker images for the Nsys Platform and for information regarding contributions 
and issues.

[1]: https://nsys.org
[2]: http://code.nsys.org
[3]: http://doc.nsys.org/display/NSYS/Nsys+Installation+and+Configuration

## Docker image nsys/nsys-node

* Includes updates
* [Dockerfile and source code](https://github.com/nsys-code/nsys-docker-library)

### Build the Image

~~~~
$ docker build -t nsys/nsys-node .
~~~~

### Build the Image via script

~~~~
$ ./build-image.sh
~~~~

### Run the Image

~~~~
$ docker run -it --rm -p 9080:9080 nsys/nsys-node
~~~~

> Nsys Node Administration will be available at http://localhost:9080

### Run the Image in background

~~~~
$ docker run -d -i --name nsys-node -p 9080:9080 nsys/nsys-node
~~~~

### Run the Image in background via script

~~~~
$ ./run-image.sh
~~~~