#!/bin/bash
set -e

DOCKER_RUN_IMAGE=nagios

docker build -t "${DOCKER_RUN_IMAGE}" .

docker images
docker run -d --name "${DOCKER_RUN_IMAGE}" -p 80:80 -t "${DOCKER_RUN_IMAGE}"
docker ps -a

