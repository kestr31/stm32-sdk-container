# SDK Container for STM32CubeIDE

This repository contains a resource for building a container for STM32CubeIDE based SDK

## Major Toolchain

- `cmake 3.29.9`
- `gcc-arm-none-eabi`
- `jinja2`
- `ninja`
- `openjdk-17-jdk`

## Build

- First, create a directory `resource` in the root of the repository
- Then download the `st-stm32cubeide_*_amd64.deb_bundle.sh.zip` file from the [ST website](https://www.st.com/en/development-tools/stm32cubeide.html) and place it in the `resource` directory
- run `./scripts/build.sh` to build the container

## Deploy

- Review your absolute directory for mounting to the container
- Set the `MOUNT_DIR` variable in the `./scripts/run.sh` script to your absolute directory
- Review other configuration in the `./scripts/run.sh` script
- run `./scripts/run.sh` to deploy the container
- Then type `docker exec -it sdk-env bash` to enter the container
- IF your system is GUI compatible, you can use STM32CubeIDE GUI in the container

## Stop

- run `./scripts/stop.sh` to stop the container
- **If you did not modify `REMOVE_AFTER_EXIT` variable in the `./scripts/run.sh` script, the container will be removed after stopping**

---
