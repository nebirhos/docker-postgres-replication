Postgres Streaming Replication with Docker
==========================================

Run Postgres master:

```
docker run nebirhos/postgres-replication
```

Run Postgres slave(s):

```
docker run nebirhos/postgres-replication -e REPLICATION_ROLE=slave
```
