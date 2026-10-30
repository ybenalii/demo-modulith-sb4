# Mini-TP: ReplicaSets, rolling update and rollback

Watch how a Deployment drives ReplicaSets through an update, a rollback and a new update, on a three-node kind cluster.

## Run

Needs Docker, kind and kubectl. From this folder:

```bash
./scripts/01-check-tools.sh   # then 02, 03, 04, 06 ... 13 in order
```

Each script prints to the terminal; the real output is saved in `outputs/`. There is no script 05: the observation terminal is replaced by `outputs/NN-watch.txt` files recorded during the updates.

## Timeline

| Step | Image | What you see | Output |
|---|---|---|---|
| 1 | nginx:1.23 | 1 Deployment, 1 ReplicaSet, 3 pods on the workers | `outputs/06-deploy-v1.txt` |
| 2 | nginx:1.25 | a new ReplicaSet goes up, the old one drops to 0 | `outputs/08-watch.txt` |
| 3 | back to nginx:1.23 | the old ReplicaSet wakes up, no third one is created | `outputs/10-watch.txt` |
| 4 | nginx:1.27 | a third ReplicaSet, the two old ones stay at 0 | `outputs/11-watch.txt` |

History and `revisionHistoryLimit` are in `outputs/09-history.txt` and `outputs/12-history-limit.txt`.

## Key takeaways

- A Deployment drives ReplicaSets; one ReplicaSet is one version of the pod template.
- A rolling update raises the new ReplicaSet while the old one goes down to 0.
- A rollback reuses the old ReplicaSet and creates a new revision number.
- Old ReplicaSets stay at 0 up to `revisionHistoryLimit` (10 by default).
- With a limit of 0, `kubectl rollout undo` fails: no history is left.
