#!/usr/bin/env bash
set -euo pipefail

kubectl get deployment mon-site -n tp-rs -o jsonpath='{.spec.revisionHistoryLimit}{"\n"}'

kubectl patch deployment/mon-site -n tp-rs -p '{"spec":{"revisionHistoryLimit":2}}'
kubectl get rs -n tp-rs

kubectl patch deployment/mon-site -n tp-rs -p '{"spec":{"revisionHistoryLimit":0}}'
sleep 5
kubectl get rs -n tp-rs

kubectl rollout undo deployment/mon-site -n tp-rs || true
