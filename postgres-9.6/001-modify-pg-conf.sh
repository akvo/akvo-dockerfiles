#!/usr/bin/env bash

set -eu

PGDATA="${PGDATA:=/var/lib/postgresql/data}"

# Enable SSL
sed -i \
    -e "s|^#ssl = off|ssl = on|" \
    -e "s|^#ssl_cert_file =.*|ssl_cert_file = '${PGDATA}/server.crt'|" \
    -e "s|^#ssl_key_file =.*|ssl_key_file = '${PGDATA}/server.key'|" \
    "${PGDATA}/postgresql.conf"

# Force SSL
#sed -i \
#    -e "/^host/d" \
#    -e "/^local/d" "${PGDATA}/pg_hba.conf"

echo "hostssl  all  all  0.0.0.0/0  md5" >> "${PGDATA}/pg_hba.conf"
