#!/bin/bash

CONTAINER_NAME=sdk-env

# check if container is running
if [ -z $(docker ps -q -f name=${CONTAINER_NAME}) ]; then
    echo "Container ${CONTAINER_NAME} is not running"
    exit 1
fi

# kill container
docker stop ${CONTAINER_NAME}