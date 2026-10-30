#!/usr/bin/env bash
set -euo pipefail

COLS='NAME:.metadata.name,DESIRED:.spec.replicas,CURRENT:.status.replicas,'
COLS+='READY:.status.readyReplicas,IMAGE:.spec.template.spec.containers[0].image'
PCOLS='NAME:.metadata.name,READY:.status.containerStatuses[0].ready,'
PCOLS+='IMAGE:.spec.containers[0].image'

kubectl get rs -n tp-rs -w > outputs/11-watch.txt &
WATCH_PID=$!

kubectl set image deployment/mon-site nginx=nginx:1.27 -n tp-rs
kubectl annotate deployment/mon-site -n tp-rs \
  kubernetes.io/change-cause="passage en nginx 1.27"
kubectl rollout status deployment/mon-site -n tp-rs
kubectl get rs -n tp-rs -o custom-columns="$COLS"
kubectl rollout history deployment/mon-site -n tp-rs
kubectl get pods -n tp-rs -o custom-columns="$PCOLS"

sleep 2
kill "$WATCH_PID"
