#!/usr/bin/env bash
set -euo pipefail

docker version --format '{{.Server.Version}}'
kind version
kubectl version --client
