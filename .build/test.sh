#!/usr/bin/env bash

set -eux

function build {
  local -r tag="docker.pkg.github.com/bendavies/docker-inline-cache-fail/php:latest"

  ~/.docker/cli-plugins/docker-buildx build \
    --progress plain \
    --cache-to=type=inline \
    --cache-from=type=registry,ref="$tag" \
    --target php \
    --tag "$tag" \
    --push \
    -f Dockerfile .
}

build