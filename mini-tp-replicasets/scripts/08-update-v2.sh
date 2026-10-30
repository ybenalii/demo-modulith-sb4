#!/usr/bin/env bash
set -euo pipefail

COLS='NAME:.metadata.name,DESIRED:.spec.replicas,CURRENT:.status.replicas,'
COLS+='READY:.status.readyReplicas,IMAGE:.spec.template.spec.containers[0].image'

kubectl get rs -n tp-rs -w > outputs/08-watch.txt &
WATCH_PID=$!

kubectl set image deployment/mon-site nginx=nginx:1.25 -n tp-rs
kubectl rollout status deployment/mon-site -n tp-rs
kubectl get rs -n tp-rs -o custom-columns="$COLS"

sleep 2
kill "$WATCH_PID"
