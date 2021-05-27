# Postgres Streaming Replication

[![Build Status](https://travis-ci.org/nebirhos/docker-postgres-replication.svg?branch=master)](https://travis-ci.org/nebirhos/docker-postgres-replication)
[![](https://imagelayers.io/badge/nebirhos/postgres-replication:latest.svg)](https://imagelayers.io/?images=nebirhos/postgres-replication:latest "Get your own badge on imagelayers.io")

Enhanced version of the official Postgres image to support streaming replication
out of the box.

Postgres-replication is meant to be used with orchestration systems such as Kubernetes.

## Tags

Images are automatically updated when the [official postgres image](https://hub.docker.com/_/postgres/) is updated.

Supported tags:

- 9.6, 9, latest ([9.6](https://github.com/nebirhos/docker-postgres-replication/tree/9.6))
- 9.5 ([9.5](https://github.com/nebirhos/docker-postgres-replication/tree/9.5))
- 12.3 ([12.3](https://github.com/nebirhos/docker-postgres-replication/tree/12.3))

## Run with Docker Compose

```sh
docker-compose up
```

Then you can try to make somes changes on master

```sh
docker exec -it docker-postgres-replication_postgres-master_1 psql -U postgres
```

```sql
postgres=# create database test;
postgres=# \c test
test=# create table posts (title text);
test=# insert into posts values ('it works');
```

Then changes will appear on slave

```sh
docker exec docker-postgres-replication_postgres-slave_1 psql -U postgres test -c 'select * from posts'
  title
----------
 it works
(1 row)
```

### Exemple of `docker-compose.yml`

```yml
version: "3.3"
services:
  postgres:
    image: nebirhos/postgres-replication:12.3
    shm_size: "2gb"
    environment:
      POSTGRES_USER: nebirhos
      POSTGRES_PASSWORD: password
      REPLICATION_USER: nebirhos_rep
      REPLICATION_PASSWORD: password
    ports:
      - 5432:5432
    expose:
      - 5432

  postgres-slave:
    image: nebirhos/postgres-replication:12.3
    links:
      - postgres
    environment:
      POSTGRES_USER: nebirhos
      POSTGRES_PASSWORD: password
      REPLICATION_USER: nebirhos_rep
      REPLICATION_PASSWORD: password
      REPLICATION_ROLE: slave
      POSTGRES_MASTER_SERVICE_HOST: postgres
    expose:
      - 5432
    depends_on:
      - postgres
```

## Run with Docker

To run with Docker, first run the Postgres master:

```sh
docker run -p 127.0.0.1:5432:5432 --name postgres-master nebirhos/postgres-replication
```

Then Postgres slave(s):

```
docker run -p 127.0.0.1:5433:5432 --link postgres-master \
           -e POSTGRES_MASTER_SERVICE_HOST=postgres-master \
           -e REPLICATION_ROLE=slave \
           -t nebirhos/postgres-replication
```

## Notes

Replication is set up at container start by putting scripts in the `/docker-entrypoint-initdb.d` folder. This way the original Postgres image scripts are left untouched.

See [Dockerfile](Dockerfile) and [official Postgres image](https://hub.docker.com/_/postgres/) for custom environment variables.
