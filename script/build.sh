#!/bin/bash
set -euxo pipefail

cd "$(dirname "$0")/"
repository_root="$(pwd)/../"

docker_image_name="reazonspeech"
docker_image_version="$(cat "${repository_root}/reazonspeech_version")"
docker buildx create --use
docker buildx build \
    --build-arg REAZONSPEECH_VERSION="${docker_image_version}" \
    -f "${repository_root}/Dockerfile" \
    -t "${docker_image_name}:${docker_image_version}" \
    --load \
    .
