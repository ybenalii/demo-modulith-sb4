# demo-modulith-sb4

Small Spring Modulith project with two modules, `catalog` and `inventory`, that talk to each other through an event instead of calling each other directly.

When you create a coffee with `POST /coffees`, `catalog` saves it and publishes a `CoffeeCreated` event. `inventory` listens to that event and creates the stock row for the coffee (quantity 0). `catalog` never calls `inventory`.

Stack: Java 25, Spring Boot 4.0.8, Spring Modulith 2.0.8, Spring Data JPA, H2 (in memory), Maven.

## Run it

```
./mvnw spring-boot:run
curl -X POST "http://localhost:8080/coffees?name=Espresso&price=3"
./mvnw test
```

H2 console: http://localhost:8080/h2-console (JDBC URL is printed in the startup logs, user `sa`, empty password).

## Screenshots

**Startup.** Hibernate creates the three tables: `coffee_entity`, `stock_entity` and `event_publication`. The last one is created by Modulith to keep track of published events.

![Startup](docs/images/01-demarrage.png)

**Creating two coffees.** Each call returns the id of the new coffee.

![POST /coffees](docs/images/02-post-coffees.png)

**SQL in the logs.** For each coffee: insert the coffee, register the event, mark it as processing, insert the stock row (done by `inventory`), mark the event as completed.

![SQL logs](docs/images/03-logs-sql.png)

**H2 console: coffees and stock.** Two coffees, and two stock rows that nobody created by hand.

![Coffee and stock tables](docs/images/04-h2-coffee-stock.png)

**H2 console: event registry.** Both events are stored and marked `COMPLETED`.

![event_publication table](docs/images/05-h2-event-publication.png)

**Tests.** All 3 tests pass.

![Tests](docs/images/06-tests-ok.png)

**Module boundary check.** I temporarily made `InventoryListener` use `catalog.internal.CoffeeRepository` (a class `catalog` keeps private). It still compiles, but `ModularityTests` fails. Removing it makes the test pass again.

![Modulith violation](docs/images/07-violation-modulith.png)

## Tests

- `ModularityTests`: checks that no module uses another module's `internal` package.
- `InventoryModuleTests`: starts only the `inventory` module, publishes a `CoffeeCreated` event and waits for the stock row.
- `DemoModulithSb4ApplicationTests`: the whole app starts.

The screenshots come from the real app and real commands, run from a clean copy of this repo. The violation screenshot was taken on a temporary copy with the forbidden access added.

## Kubernetes exercises

The same application is reused for exercises with [kind](https://kind.sigs.k8s.io/).

| Part | Folder / files | Topic | Status |
|---|---|---|---|
| Mini-TP | `mini-tp-replicasets/` | Deployment, ReplicaSets, rolling update, rollback, `revisionHistoryLimit` | done |
| J2 | `kind-cluster.yaml`, `k8s/`, `src/` | Modulith on kind: buildpacks image, Service, probes, scaling, Postgres with Secret, ConfigMap and PVC | in progress |

Requirements: Docker, kind 0.30+, kubectl, JDK 21+, bash.

### Mini-TP: ReplicaSets and rollback

```bash
cd mini-tp-replicasets
./scripts/01-check-tools.sh   # then the next scripts, in order
```

Each script's real output is kept in `mini-tp-replicasets/outputs/`.

### J2: Modulith on Kubernetes

```bash
kind create cluster --name formation --config kind-cluster.yaml
./mvnw spring-boot:build-image -DskipTests
kind load docker-image demo-modulith-sb4:0.0.1 --name formation
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/
kubectl port-forward -n shop svc/modulith 8080:80
```

```bash
curl -s -X POST "http://localhost:8080/coffees?name=Arabica&price=5"
curl -s http://localhost:8080/coffees
curl -s http://localhost:8080/stocks/1
```

Command outputs for each step are in `outputs/j2/`.

---

> **Note:** this repository contains school assignments completed as part of the EPITA curriculum.
> The topics were set by the course and do not necessarily reflect my personal project interests.
