#!/usr/bin/env bash
set -euo pipefail

COLS='NAME:.metadata.name,DESIRED:.spec.replicas,CURRENT:.status.replicas,'
COLS+='READY:.status.readyReplicas,IMAGE:.spec.template.spec.containers[0].image'

kubectl patch deployment/mon-site -n tp-rs -p '{
  "spec": {
    "minReadySeconds": 5,
    "strategy": { "rollingUpdate": { "maxSurge": 1, "maxUnavailable": 1 } }
  }
}'
kubectl get rs -n tp-rs -o custom-columns="$COLS"
