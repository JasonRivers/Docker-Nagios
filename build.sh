#!/bin/bash
set -e

DOCKER_RUN_IMAGE=nagios-server
DOCKER_RUN_PORTS=8080:80
DOCKER_EXTRA_ARG=
DOCKER_EXTRA_ARG="$DOCKER_EXTRA_ARG -v /srv/nagios/nagios-confs:/opt/nagios/etc"
DOCKER_EXTRA_ARG="$DOCKER_EXTRA_ARG -v /srv/nagios/nrdp-confs:/usr/local/share/confs"

docker build -t "${DOCKER_RUN_IMAGE}" .

docker images
docker run -d --name "${DOCKER_RUN_IMAGE}" -p ${DOCKER_RUN_PORTS} ${DOCKER_EXTRA_ARG} -t "${DOCKER_RUN_IMAGE}"
docker ps -a

