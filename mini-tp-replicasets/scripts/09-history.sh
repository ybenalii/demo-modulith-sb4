#!/usr/bin/env bash
set -euo pipefail

kubectl rollout history deployment/mon-site -n tp-rs
kubectl rollout history deployment/mon-site -n tp-rs --revision=1
kubectl rollout history deployment/mon-site -n tp-rs --revision=2
