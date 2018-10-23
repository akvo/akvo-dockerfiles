#!/usr/bin/env bash

set -eu
ON_ERROR_STOP=1
export ON_ERROR_STOP

# Provision

## Create lumen role
psql -v --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
  CREATE USER lumen WITH CREATEDB PASSWORD 'password';
EOSQL

## Create lumen dbs
psql -v --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
CREATE DATABASE lumen
WITH OWNER = lumen
     TEMPLATE = template0
     ENCODING = 'UTF8'
     LC_COLLATE = 'en_US.UTF-8'
     LC_CTYPE = 'en_US.UTF-8';

CREATE DATABASE test_lumen
WITH OWNER = lumen
     TEMPLATE = template0
     ENCODING = 'UTF8'
     LC_COLLATE = 'en_US.UTF-8'
     LC_CTYPE = 'en_US.UTF-8';
EOSQL

EXTENSIONS="
  CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
  CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
  CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;
  CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;"

## Create extensions for dbs
psql -v --dbname lumen --command "${EXTENSIONS}"

psql -v --dbname test_lumen --command "${EXTENSIONS}"

## Create tenants dbs
psql -v --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL

CREATE DATABASE lumen_tenant_1
WITH OWNER = lumen
     TEMPLATE = template0
     ENCODING = 'UTF8'
     LC_COLLATE = 'en_US.UTF-8'
     LC_CTYPE = 'en_US.UTF-8';

CREATE DATABASE lumen_tenant_2
WITH OWNER = lumen
     TEMPLATE = template0
     ENCODING = 'UTF8'
     LC_COLLATE = 'en_US.UTF-8'
     LC_CTYPE = 'en_US.UTF-8';

CREATE DATABASE test_lumen_tenant_1
WITH OWNER = lumen
     TEMPLATE = template0
     ENCODING = 'UTF8'
     LC_COLLATE = 'en_US.UTF-8'
     LC_CTYPE = 'en_US.UTF-8';

CREATE DATABASE test_lumen_tenant_2
WITH OWNER = lumen
     TEMPLATE = template0
     ENCODING = 'UTF8'
     LC_COLLATE = 'en_US.UTF-8'
     LC_CTYPE = 'en_US.UTF-8';
EOSQL

## Create extensions for dbs
psql --dbname lumen_tenant_1 --command "${EXTENSIONS}"
psql --dbname lumen_tenant_2 --command "${EXTENSIONS}"
psql --dbname test_lumen_tenant_1 --command "${EXTENSIONS}"
psql --dbname test_lumen_tenant_2 --command "${EXTENSIONS}"

echo "----------"
echo "Done!"
