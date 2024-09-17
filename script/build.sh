#!/bin/bash
set -euxo pipefail

cd "$(dirname "$0")/"
repository_root="$(pwd)/../"

docker_image_name="reazonspeech"
docker_image_version="$(cat "${repository_root}/reazonspeech_version")"

# Check if a builder instance already exists
if ! docker buildx inspect default &>/dev/null; then
  docker buildx create --name default --use
else
  docker context use default
fi

docker buildx build \
    --build-arg REAZONSPEECH_VERSION="${docker_image_version}" \
    -f "${repository_root}/Dockerfile" \
    -t "${docker_image_name}:${docker_image_version}" \
    --load \
    --no-cache \
    .
