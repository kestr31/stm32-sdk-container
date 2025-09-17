ARG BASEIMAGE=ubuntu
ARG BASETAG=22.04

# STAGE FOR CACHING APT PACKAGE LIST
FROM ${BASEIMAGE}:${BASETAG} AS stage_apt

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN \
    rm -rf /etc/apt/apt.conf.d/docker-clean \
	&& echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache \
	&& apt-get update

# STAGE FOR INSTALLING APT DEPENDENCIES
FROM ${BASEIMAGE}:${BASETAG} AS stage_deps

ARG CUBEIDE_FILENAME
ARG CUBEIDE_VERSION_ALL
ARG CUBEIDE_VERSION_MAJOR

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LICENSE_ALREADY_ACCEPTED=1

COPY deps/aptDeps.txt /tmp/aptDeps.txt

# INSTALL APT DEPENDENCIES USING CACHE OF stage_apt
RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_apt,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_apt,source=/var/lib/apt \
    --mount=type=cache,target=/etc/apt/sources.list.d,from=stage_apt,source=/etc/apt/sources.list.d \
	apt-get install --no-install-recommends -y $(cat /tmp/aptDeps.txt) \
    && rm -rf /tmp/*

COPY deps/pyDeps.txt /tmp/pyDeps.txt

RUN \
    pip install -r /tmp/pyDeps.txt

RUN \
    wget -qO- "https://cmake.org/files/v3.29/cmake-3.29.9-linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr/local


COPY \
    resource/${CUBEIDE_FILENAME} \
    /tmp/${CUBEIDE_FILENAME}

# INSTALL STM32CUBECTL
RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_apt,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_apt,source=/var/lib/apt \
    --mount=type=cache,target=/etc/apt/sources.list.d,from=stage_apt,source=/etc/apt/sources.list.d \
    unzip -q /tmp/${CUBEIDE_FILENAME} -d /tmp/stm32cubeide \
    && chmod +x /tmp/stm32cubeide/st-stm32cubeide_${CUBEIDE_VERSION_ALL}_amd64.deb_bundle.sh \
    && /tmp/stm32cubeide/st-stm32cubeide_${CUBEIDE_VERSION_ALL}_amd64.deb_bundle.sh \
        --target /tmp/stm32cubeide/extract --noexec \
    && apt-get install -y /tmp/stm32cubeide/extract/*.deb \
    && rm -rf /tmp/*

# ADD NON-ROOT USER user FOR RUNNING THE WEBUI
RUN \
    groupadd user \
    && useradd -ms /bin/bash user -g user \
    && echo "user ALL=NOPASSWD: ALL" >> /etc/sudoers \
    && chown -R user:user /opt/st/stm32cubeide_${CUBEIDE_VERSION_MAJOR}

USER user
WORKDIR /home/user

RUN \
    ln -s /opt/st/stm32cubeide_${CUBEIDE_VERSION_MAJOR} /home/user/STM32CubeIDE

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]