#!/usr/bin/env bash
set -euo pipefail

kind delete cluster --name tp-rs
docker ps --filter name=tp-rs
