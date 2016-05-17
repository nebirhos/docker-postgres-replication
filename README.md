Postgres Streaming Replication
==============================

Enhanced version of official Postgres image to support streaming replication
out of the box.

Postgres-replication is meant to be used with orchestration systems such as Kubernetes.


Run with Docker Compose
-----------------------

```
docker-compose up
```


Run with Docker
---------------

To run with Docker only first run Postgres master:

```
docker run -p 127.0.0.1:5432:5432 --name postgres-master nebirhos/postgres-replication
```


Then Postgres slave(s):

```
docker run -p 127.0.0.1:5433:5432 --link postgres-master \
           -e POSTGRES_MASTER_SERVICE_HOST=postgres-master \
           -e REPLICATION_ROLE=slave \
           -t nebirhos/postgres-replication
```


Notes
-----

Replication is set at container start by putting scripts in `/docker-entrypoint-initdb.d` folder.
This way original Postgres image script are left untouched.

See [Dockerfile](Dockerfile) and [official Postgres image](https://hub.docker.com/_/postgres/)
for custom environment variables.
