#!/usr/bin/env bash

set -eux

function build {
  local -r tag="bendavies/docker-inline-cache-fail:latest"

#  export DOCKER_BUILDKIT=1
#
#  docker pull "$tag" || true
#
#  docker build \
#    --build-arg BUILDKIT_INLINE_CACHE=1 \
#    --cache-from "$tag" \
#    --target php \
#    --tag "$tag" \
#    -f Dockerfile .
#
#  docker push "$tag"

  docker buildx build \
    --progress plain \
    --cache-to type=inline,mode=max \
    --cache-from type=registry,ref="$tag" \
    --target php \
    --tag "$tag" \
    --push \
    -f Dockerfile .
}

build