#!/usr/bin/env bash

set -eux

function build {
  local -r image="bendavies/docker-inline-cache-fail"

  export DOCKER_BUILDKIT=1

  docker build \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --target php \
    --tag "$image:latest" \
    -f Dockerfile .
}

build