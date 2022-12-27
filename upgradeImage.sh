#!/bin/bash

docker compose rm -svf
docker compose pull
DOCKER_BUILDKIT=1 docker compose build
docker compose up ${@}
