#!/bin/bash

set -e

export DOCKER_BUILDKIT=1

VERSION=$1
APP_NAME=kubernetes_job_runner

docker buildx build -t $APP_NAME:$VERSION --target $APP_NAME --load -f deploy/docker/Dockerfile.agent .
docker tag $APP_NAME:$VERSION $APP_NAME:latest