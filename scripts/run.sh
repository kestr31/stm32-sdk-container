#!/bin/bash

MOUNT_DIR=/home/merlin/gitcodes/RoSAT/sdk-container/endurosat-obc-sdk
REMOVE_AFTER_EXIT=true
CONTAINER_NAME=sdk-env
CONTAINER_IMAGE=sdk-env:1.12.1

# check if MOUNT_DIR exists
if [ ! -d "${MOUNT_DIR}" ]; then
    echo "MOUNT_DIR not found"
    exit 1
fi

# check remove after exit flag
if [ "${REMOVE_AFTER_EXIT}" = "true" ]; then
    REMOVE_AFTER_EXIT_FLAG="--rm"
else
    REMOVE_AFTER_EXIT_FLAG=""
fi

# deploy container
docker run -itd ${REMOVE_AFTER_EXIT_FLAG} \
  -v ${MOUNT_DIR}:/home/user/sdk \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e XDG_RUNTIME_DIR=/tmp \
  -e DISPLAY=${DISPLAY} \
  --name ${CONTAINER_NAME} \
  ${CONTAINER_IMAGE}
