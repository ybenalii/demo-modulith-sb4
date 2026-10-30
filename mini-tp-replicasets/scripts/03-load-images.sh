#!/usr/bin/env bash
set -euo pipefail

for tag in 1.23 1.25 1.27; do
  docker pull nginx:$tag
  kind load docker-image nginx:$tag --name tp-rs
done

docker exec tp-rs-worker crictl images | grep nginx
