#!/bin/bash

##########################################################################
#                                                                        #
# Docker Control Script                                                  #
# Copyright 2015, 2017 Nsys.org - Tomas Hrdlicka <tomas@hrdlicka.co.uk>  #
# All rights reserved.                                                   #
#                                                                        #
# Web: code.nsys.org                                                     #
# Git: github.com/nsys-code/nsys-docker-library                          #
#                                                                        #
##########################################################################

DOCKER_IMAGE_DIR=`pwd`
DOCKER_CMD=docker
DOCKER_NET_NAME_DEFAULT=bridge
DOCKER_ENV_SCRIPT=$DOCKER_IMAGE_DIR/docker.env.sh

dockerBuildImage() {
    if [ "$1" = "--help" ]; then
        dockerBuildImageHelp
    fi

    DOCKER_IMAGE_NAME=$1
    DOCKER_CONTAINER_NAME=${DOCKER_IMAGE_NAME////-}

    # Check whether the Docker environment runtime script exists
    if [ -e $DOCKER_ENV_SCRIPT ]; then
        . "$DOCKER_ENV_SCRIPT"
    fi

    DOCKER_CONTAINER_STATUS=`$DOCKER_CMD inspect --format={{.State.Status}} $DOCKER_CONTAINER_NAME`

    echo "Using DOCKER_IMAGE_NAME:	$DOCKER_IMAGE_NAME"
    echo "Using DOCKER_CONTAINER_NAME:	$DOCKER_CONTAINER_NAME"
    echo

    if [ "$DOCKER_CONTAINER_STATUS" = "running" ]; then
        $DOCKER_CMD stop $DOCKER_CONTAINER_NAME
        DOCKER_CONTAINER_STATUS=`$DOCKER_CMD inspect --format={{.State.Status}} $DOCKER_CONTAINER_NAME`
    fi

    if [ "$DOCKER_CONTAINER_STATUS" = "exited" ] || [ "$DOCKER_CONTAINER_STATUS" = "created" ]; then
        $DOCKER_CMD rm $DOCKER_CONTAINER_NAME
        $DOCKER_CMD rmi $DOCKER_IMAGE_NAME
    else
        DOCKER_IMAGE_COUNT=`$DOCKER_CMD images | grep $DOCKER_IMAGE_NAME | wc -l`

        if [ $DOCKER_IMAGE_COUNT -gt 0 ]; then
            $DOCKER_CMD rmi $DOCKER_IMAGE_NAME
        fi
    fi

    #$DOCKER_CMD build --pull --no-cache -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} -t ${DOCKER_IMAGE_NAME}:latest $DOCKER_IMAGE_DIR
    $DOCKER_CMD build --pull -t $DOCKER_IMAGE_NAME $DOCKER_IMAGE_DIR
}

dockerRunImage() {
    if [ "$1" = "--help" ]; then
        dockerRunImageHelp
    fi

    DOCKER_IMAGE_NAME=$1
    DOCKER_CONTAINER_NAME=${DOCKER_IMAGE_NAME////-}
    DOCKER_NET_NAME=$DOCKER_NET_NAME_DEFAULT
    DOCKER_CTL_ARGS=${*:2}

    # Check whether the Docker environment runtime script exists
    if [ -e $DOCKER_ENV_SCRIPT ]; then
        . "$DOCKER_ENV_SCRIPT"
    fi

    DOCKER_CONTAINER_STATUS=`$DOCKER_CMD inspect --format={{.State.Status}} $DOCKER_CONTAINER_NAME`
    DOCKER_NET_STATUS=`$DOCKER_CMD network inspect --format={{.Name}} $DOCKER_NET_NAME`

    echo "Using DOCKER_IMAGE_NAME:	$DOCKER_IMAGE_NAME"
    echo "Using DOCKER_CONTAINER_NAME:	$DOCKER_CONTAINER_NAME"
    echo "Using DOCKER_NET_NAME:  	$DOCKER_NET_NAME"
    echo "Using DOCKER_OPTS:		$DOCKER_CTL_ARGS $DOCKER_OPTS"
    echo

    if [ "$DOCKER_NET_STATUS" != "$DOCKER_NET_NAME" ]; then
        echo "Creating Docker bridge network '$DOCKER_NET_NAME'..."
        echo

        if [ "x$DOCKER_NET_OPTS" = "x" ]; then

            #
            # You need to run Docker daemon with parameter --iptables=true
            # See link below for more details
            #
            # iptables MASQUERADE rules not created with iptables set to off ip-masq set to true
            # https://github.com/docker/docker/issues/28133
            #

            DOCKER_NET_OPTS="-o com.docker.network.bridge.host_binding_ipv4=0.0.0.0"
            DOCKER_NET_OPTS="$DOCKER_NET_OPTS -o com.docker.network.bridge.enable_icc=true"
            DOCKER_NET_OPTS="$DOCKER_NET_OPTS -o com.docker.network.driver.mtu=1500"
            DOCKER_NET_OPTS="$DOCKER_NET_OPTS -o com.docker.network.bridge.name=${DOCKER_NET_NAME}0"
            DOCKER_NET_OPTS="$DOCKER_NET_OPTS -o com.docker.network.bridge.enable_ip_masquerade=true"
        fi

        echo "Using DOCKER_NET_OPTS:		$DOCKER_NET_OPTS"
        echo

        $DOCKER_CMD network create $DOCKER_NET_OPTS $DOCKER_NET_NAME
    fi

    if [ "$2" = "show-log" ]; then
        echo "Showing log of container '$DOCKER_CONTAINER_NAME' ..."
        echo 

        dockerContainerInfo $DOCKER_CONTAINER_NAME

        $DOCKER_CMD logs $DOCKER_CONTAINER_NAME -f
        return 0

    elif [ "$2" = "create" ]; then
        echo "Creating new instance of container '$DOCKER_CONTAINER_NAME' ..."
        echo

        if [ "$DOCKER_CONTAINER_STATUS" = "running" ]; then
            $DOCKER_CMD stop $DOCKER_CONTAINER_NAME
        fi

        DOCKER_CTL_ARGS=${*:3}
        DOCKER_CONTAINER_STATUS=stopped

        $DOCKER_CMD rm $DOCKER_CONTAINER_NAME
    fi

    if [ "$DOCKER_CONTAINER_STATUS" = "exited" ] || [ "$DOCKER_CONTAINER_STATUS" = "created" ]; then
        $DOCKER_CMD start $DOCKER_CONTAINER_NAME
        DOCKER_CONTAINER_STATUS=`$DOCKER_CMD inspect --format={{.State.Status}} $DOCKER_CONTAINER_NAME`
    fi

    if [ "$DOCKER_CONTAINER_STATUS" = "running" ]; then
        dockerContainerInfo $DOCKER_CONTAINER_NAME
        $DOCKER_CMD exec -it $DOCKER_CONTAINER_NAME /bin/bash

    else
	$DOCKER_CMD run -d -i --name $DOCKER_CONTAINER_NAME --net $DOCKER_NET_NAME $DOCKER_CTL_ARGS $DOCKER_OPTS $DOCKER_IMAGE_NAME

        echo
        dockerContainerInfo $DOCKER_CONTAINER_NAME

        $DOCKER_CMD logs $DOCKER_CONTAINER_NAME -f
    fi
}

dockerStopImage() {
    if [ "$1" = "--help" ]; then
        dockerStopImageHelp
    fi

    DOCKER_IMAGE_NAME=$1
    DOCKER_CONTAINER_NAME=${DOCKER_IMAGE_NAME////-}

    # Check whether the Docker environment runtime script exists
    if [ -e $DOCKER_ENV_SCRIPT ]; then
        . "$DOCKER_ENV_SCRIPT"
    fi

    echo "Using DOCKER_IMAGE_NAME:	$DOCKER_IMAGE_NAME"
    echo "Using DOCKER_CONTAINER_NAME:	$DOCKER_CONTAINER_NAME"
    echo

    $DOCKER_CMD stop $DOCKER_CONTAINER_NAME
}

dockerLogImage() {
    if [ "$1" = "--help" ]; then
        dockerLogImageHelp
    fi

    DOCKER_IMAGE_NAME=$1
    DOCKER_CONTAINER_NAME=${DOCKER_IMAGE_NAME////-}

    # Check whether the Docker environment runtime script exists
    if [ -e $DOCKER_ENV_SCRIPT ]; then
        . "$DOCKER_ENV_SCRIPT"
    fi

    echo "Using DOCKER_IMAGE_NAME:	$DOCKER_IMAGE_NAME"
    echo "Using DOCKER_CONTAINER_NAME:	$DOCKER_CONTAINER_NAME"
    echo

    dockerContainerInfo $DOCKER_CONTAINER_NAME

    echo "Showing log of container '$DOCKER_CONTAINER_NAME' ..."
    echo

    $DOCKER_CMD logs $DOCKER_CONTAINER_NAME -f
}

dockerContainerInfo() {
    DOCKER_CONTAINER_NAME=$1
    DOCKER_CONTAINER_IPV4=`$DOCKER_CMD inspect --format={{.NetworkSettings.IPAddress}} $DOCKER_CONTAINER_NAME`

    echo "Container IPv4 Address:		$DOCKER_CONTAINER_IPV4"
    echo
}

appHeader() {
    echo
    echo "Docker Control Script"
    echo "Copyright 2015, 2017 Nsys.org - Tomas Hrdlicka <tomas@hrdlicka.co.uk>"
    echo "All rights reserved."
    echo
    echo "Web: code.nsys.org"
    echo "Git: github.com/nsys-code/nsys-docker-library"
    echo
}

appHelp() {
    echo "Usage: $0 COMMAND [args...]"
    echo
    echo "Commands:"
    echo "    build    Build an image from a Dockerfile"
    echo "    run      Start new container. If stopped then the container is started up again."
    echo "             If running then the console appears."
    echo "    stop     Stop a container"
    echo "    log      Show log of a container"
    echo
    echo "Run '$0 COMMAND --help' for more information on a command."
    echo
}

dockerBuildImageHelp() {
    echo
    echo "Usage: $0 build IMAGE_NAME"
    echo
    echo "Build an image from a Dockerfile"
    echo
    echo "Example: $0 build nsys/ubuntu"
    echo
    exit 0
}

dockerRunImageHelp() {
    echo
    echo "Usage: $0 run [OPTIONS]"
    echo
    echo "Start new container. If stopped then the container is started up again."
    echo "If running then the console appears."
    echo
    echo "Options:"
    echo "    run $IMAGE_NAME show-log    Show log of running container"
    echo "    run $IMAGE_NAME create      Create and run new instance of container"
    echo
    echo "Examples:"
    echo "           $0 run nsys/ubuntu -p 8080:8080 -v /home/user:/mnt/share"
    echo "           $0 run nsys/ubuntu create"
    echo "           $0 run nsys/ubuntu show-log"
    echo
    exit 0
}

dockerStopImageHelp() {
    echo
    echo "Usage: $0 stop IMAGE_NAME"
    echo
    echo "Stop a container"
    echo
    echo "Example: $0 stop nsys/ubuntu"
    echo
    exit 0
}

dockerLogImageHelp() {
    echo
    echo "Usage: $0 log IMAGE_NAME"
    echo
    echo "Show log of a container"
    echo
    echo "Example: $0 log nsys/ubuntu"
    echo
    exit 0
}

appHeader

case "$1" in
    build)
	    dockerBuildImage $2
	    ;;
    run)
	    dockerRunImage $2 ${*:3}
	    ;;
    stop)
	    dockerStopImage $2
	    ;;
    log)
	    dockerLogImage $2
	    ;;
    *)
	    appHelp
esac

exit $?
