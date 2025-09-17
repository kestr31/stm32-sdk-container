#!/bin/bash

# ENTYPOINT SCRIPT TO DEPLOY SpaceDev DEVELOPMENT ENVIRONMENT

# IF UID IS SET, CHANGE THE UID OF THE USER
if [ ! -z ${PUID} ]; then
    usermod -u ${PUID} user
fi

# IF GID IS SET, CHANGE THE GID OF THE USER
if [ ! -z ${PGID} ]; then
    groupmod -g ${PGID} user
fi

sleep infinity
