#!/usr/bin/env bash
set -euo pipefail

cat kind-tp-rs.yaml
kind create cluster --name tp-rs --config kind-tp-rs.yaml
kubectl config current-context
kubectl wait --for=condition=Ready nodes --all --timeout=120s
kubectl get nodes
