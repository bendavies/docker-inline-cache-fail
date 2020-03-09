#!/usr/bin/env bash

set -eux

function build {
  local -r tag="bendavies/docker-inline-cache-fail:latest"
  local -r cache_tag="bendavies/docker-inline-cache-fail:cache"

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
    --cache-from "type=registry,ref=$cache_tag" \
    --cache-to "type=registry,ref=$cache_tag,mode=max" \
    --target php \
    --tag "$tag" \
    --push \
    -f Dockerfile .
}

build
