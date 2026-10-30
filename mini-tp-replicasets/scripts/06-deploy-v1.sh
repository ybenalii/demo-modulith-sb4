#!/usr/bin/env bash
set -euo pipefail

COLS='NAME:.metadata.name,DESIRED:.spec.replicas,CURRENT:.status.replicas,'
COLS+='READY:.status.readyReplicas,IMAGE:.spec.template.spec.containers[0].image'

kubectl create deployment mon-site --image=nginx:1.23 --replicas=3 -n tp-rs
kubectl rollout status deployment/mon-site -n tp-rs
kubectl get deploy,rs,pods -n tp-rs
kubectl get pods -n tp-rs -o wide
kubectl get rs -n tp-rs -o custom-columns="$COLS"
