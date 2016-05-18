Postgres Streaming Replication
==============================

[![Build Status](https://travis-ci.org/nebirhos/docker-postgres-replication.svg?branch=master)](https://travis-ci.org/nebirhos/docker-postgres-replication)
[![](https://imagelayers.io/badge/nebirhos/postgres-replication:latest.svg)](https://imagelayers.io/?images=nebirhos/postgres-replication:latest 'Get your own badge on imagelayers.io')


Enhanced version of the official Postgres image to support streaming replication
out of the box.

Postgres-replication is meant to be used with orchestration systems such as Kubernetes.


Run with Docker Compose
-----------------------

```
docker-compose up
```


Run with Docker
---------------

To run with Docker, first run the Postgres master:

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

Replication is set up at container start by putting scripts in the `/docker-entrypoint-initdb.d` folder.
This way the original Postgres image scripts are left untouched.

See [Dockerfile](Dockerfile) and [official Postgres image](https://hub.docker.com/_/postgres/)
for custom environment variables.
