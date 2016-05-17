#!/bin/bash
set -e

echo [*] configuring $REPLICATION_ROLE instance

echo "max_connections = $MAX_CONNECTIONS" >> "$PGDATA/postgresql.conf"

# We set master replication-related parameters for both slave and master,
# so that the slave might work as a primary after failover.
echo "wal_level = hot_standby" >> "$PGDATA/postgresql.conf"
echo "wal_keep_segments = 256" >> "$PGDATA/postgresql.conf"
echo "max_wal_senders = 100" >> "$PGDATA/postgresql.conf"
# slave settings, ignored on master
echo "hot_standby = on" >> "$PGDATA/postgresql.conf"


echo "host replication $REPLICATION_USER 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"
