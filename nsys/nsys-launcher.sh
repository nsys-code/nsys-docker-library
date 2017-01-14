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

echo
echo "Starting up Nsys Portal..."
echo

NSYS_PORTAL_SCRIPT=/etc/init.d/nsys-portal

if [ ! -e $NSYS_PORTAL_SCRIPT ]; then
    echo "Unable to find '$NSYS_PORTAL_SCRIPT'! Fatal error! Terminating script..."
    echo
    exit 1
fi

$NSYS_PORTAL_SCRIPT run
