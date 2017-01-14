#!/bin/bash

##########################################################################
#                                                                        #
# Nsys Docker Library                                                    #
# Copyright 2015, 2017 Nsys.org - Tomas Hrdlicka <tomas@hrdlicka.co.uk>  #
# All rights reserved.                                                   #
#                                                                        #
# Web: code.nsys.org                                                     #
# Git: github.com/nsys-code/nsys-docker-library                          #
#                                                                        #
##########################################################################

DOCKER_IMAGE_NAME=nsys/debian
DOCKER_IMAGE_TAG=jessie
DOCKERCTL_CMD="$( cd "$(dirname "$0")" ; pwd -P )/../../scripts/docker-ctl.sh"

echo
echo "Running application:		$DOCKERCTL_CMD"
echo "Docker image name:		$DOCKER_IMAGE_NAME"

$DOCKERCTL_CMD stop $DOCKER_IMAGE_NAME
