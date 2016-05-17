# -*- mode: conf -*-
FROM postgres:9.5

MAINTAINER me@nebirhos.com

# postgresql.conf tweaks
ENV MAX_CONNECTIONS 500

# common settings
ENV REPLICATION_ROLE master
ENV REPLICATION_USER replication
ENV REPLICATION_PASSWORD ""

# slave settings
ENV POSTGRES_MASTER_SERVICE_HOST localhost
ENV POSTGRES_MASTER_SERVICE_PORT 5432

COPY 10-config.sh /docker-entrypoint-initdb.d/
COPY 20-replication.sh /docker-entrypoint-initdb.d/
# Evaluate vars inside PGDATA (eg PGDATA=/mnt/$HOSTNAME)
RUN sed -i 's/set -e/set -e -x\nPGDATA=$(eval echo "$PGDATA")/' /docker-entrypoint.sh
