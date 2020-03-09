#!/usr/bin/env bash

set -eux

function build {
  local -r tag="docker.pkg.github.com/bendavies/docker-inline-cache-fail/php:latest"

  export DOCKER_BUILDKIT=1

  docker build \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --target php \
    --tag "$tag" \
    -f Dockerfile .

  docker push "$tag"

  #~/.docker/cli-plugins/docker-buildx build \
  #  --progress plain \
  #  --cache-to=type=inline \
  #  --cache-from=type=registry,ref="$tag" \
  #  --target php \
  #  --tag "$tag" \
  #  --push \
  #  -f Dockerfile .
}

build