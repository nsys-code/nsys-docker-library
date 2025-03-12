#!/bin/bash

##########################################################################
#                                                                        #
# Nsys Docker Library                                                    #
# Copyright 2015, 2025 Nsys.org - Tomas Hrdlicka <tomas@hrdlicka.co.uk>  #
# All rights reserved.                                                   #
#                                                                        #
# Web: code.nsys.org                                                     #
# Git: github.com/nsys-code/nsys-docker-library                          #
#                                                                        #
##########################################################################

DOCKER_IMAGE_NAME=nsys/ubuntu
DOCKER_IMAGE_TAG=24.04
DOCKERCTL_CMD="$( cd "$(dirname "$0")" ; pwd -P )/../../scripts/docker-ctl.sh"
DOCKER_OPTS="$1 -v `pwd`:/mnt/share"

echo
echo "Running application:		$DOCKERCTL_CMD"
echo "Docker image name:		$DOCKER_IMAGE_NAME"

$DOCKERCTL_CMD run $DOCKER_IMAGE_NAME $DOCKER_OPTS
