#!/bin/bash

set -e

export DOCKER_BUILDKIT=1

VERSION=v0.0.1
APP_NAME=sample_app_2

docker buildx build -t $APP_NAME:$VERSION --target $APP_NAME --load -f deploy/docker/Dockerfile.sample_app_2 .
docker tag $APP_NAME:$VERSION $APP_NAME:latest