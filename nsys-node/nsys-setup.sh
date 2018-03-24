#!/bin/bash

##########################################################################
#                                                                        #
# Nsys Docker Library                                                    #
# Copyright 2015, 2018 Nsys.org - Tomas Hrdlicka <tomas@hrdlicka.co.uk>  #
# All rights reserved.                                                   #
#                                                                        #
# Web: code.nsys.org                                                     #
# Git: github.com/nsys-code/nsys-docker-library                          #
#                                                                        #
##########################################################################

NSYS_INST_SCRIPT=nsys-installer.sh
NSYS_INST_SCRIPT_URL=https://raw.githubusercontent.com/nsys-code/nsys-scripts/master/nsys/$NSYS_INST_SCRIPT
NSYS_BUNDLE_FILE=nsys-bundle.zip
NSYS_BUNDLE_PATH=/tmp/$NSYS_BUNDLE_FILE

echo
echo "Downloading '$NSYS_INST_SCRIPT' script..."
echo

curl -o $NSYS_INST_SCRIPT $NSYS_INST_SCRIPT_URL
chmod a+x $NSYS_INST_SCRIPT
./$NSYS_INST_SCRIPT

if [ -e $NSYS_BUNDLE_PATH ]; then
    echo "Removing file '$NSYS_BUNDLE_PATH' with Nsys Platform bundle..."
    echo
    rm $NSYS_BUNDLE_PATH
fi

exit $?
