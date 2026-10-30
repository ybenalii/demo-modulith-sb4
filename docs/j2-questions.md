# J2 reflection questions

## Why does a Service not know its pods in advance? What happens when a pod is recreated elsewhere?

A Service only holds a label selector (`app: modulith`). Its endpoints are computed continuously from the ready pods matching that selector. When a pod is recreated on another node it gets a new IP, the old one leaves the EndpointSlice and the new one is added once it is ready, so clients keep using the same Service name.

## Why does the port-forward tunnel not show the distribution between pods?

`kubectl port-forward svc/modulith` picks one pod when the tunnel starts and sends all traffic to that pod through a single stream. It bypasses the Service load balancing done by kube-proxy. Only requests made from inside the cluster, through the Service, are spread across the pods.

## What would happen if the liveness probe checked access to Postgres?

If the database became unavailable, every Modulith pod would fail its liveness probe and be restarted, even though restarting does not fix Postgres. This would create a cascade of restarts and make the recovery slower. The liveness probe should only check the process itself; dependencies belong, at most, in readiness.

## Do 3 pods sharing the same database suffice to split the application into several services?

No. Sharing one database means the modules are still coupled through the same tables and the same schema. Each service should own its data and communicate through an API or messages instead of shared tables, which means splitting the schema and moving the Modulith events to an external broker.
