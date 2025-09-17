#!/bin/bash

# get directory for this script
BASE_DIR=$(dirname $(realpath $0))
REPO_DIR=$(dirname ${BASE_DIR})

# check if resource folder exists
if [ ! -d "${REPO_DIR}/resource" ]; then
    echo "${REPO_DIR}/resource folder not found"
    exit 1
fi

# check if st-stm32cubeide_1.12.1_*_amd64.deb_bundle.sh.zip exists in resource directory
if [ -z $(compgen -G "${REPO_DIR}/resource/st-stm32cubeide_*_amd64.deb_bundle.sh.zip") ]; then
    echo "st-stm32cubeide_*_amd64.deb_bundle.sh.zip not found in ${REPO_DIR}/resource folder"
    exit 1
fi


# extract filename and version numbers
CUBEIDE_FILENAME=$(echo $(compgen -G "${REPO_DIR}/resource/st-stm32cubeide_*_amd64.deb_bundle.sh.zip") | sed 's/.*\///')
CUBEIDE_VERSION_ALL=$(echo ${CUBEIDE_FILENAME} | sed 's/.*st-stm32cubeide_\(.*\)_amd64.deb_bundle.sh.zip/\1/')
CUBEIDE_VERSION_MAJOR=$(echo ${CUBEIDE_FILENAME} | sed 's/.*st-stm32cubeide_\(.*\)_amd64.deb_bundle.sh.zip/\1/' | sed 's/_.*//')

echo CUBEIDE_FILENAME: ${CUBEIDE_FILENAME}
echo CUBEIDE_VERSION_ALL: ${CUBEIDE_VERSION_ALL}
echo CUBEIDE_VERSION_MAJOR: ${CUBEIDE_VERSION_MAJOR}

# build docker image
docker build \
    --build-arg CUBEIDE_FILENAME=${CUBEIDE_FILENAME} \
    --build-arg CUBEIDE_VERSION_MAJOR=${CUBEIDE_VERSION_MAJOR} \
    --build-arg CUBEIDE_VERSION_ALL=${CUBEIDE_VERSION_ALL} \
    -t sdk-env:${CUBEIDE_VERSION_MAJOR} ${REPO_DIR}