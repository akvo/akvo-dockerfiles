#!/usr/bin/env bash

set -eux
ON_ERROR_STOP=1
export ON_ERROR_STOP

POSTGRES_USER=postgres
POSTGRES_DB=postgres
POSTGRES_USER_PASSWORD="the password for the postgres user in Google Cloud SQL"

psql_settings=("--username=${POSTGRES_USER}" "--host=localhost")
export PGPASSWORD=$POSTGRES_USER_PASSWORD

# Provision
## Create lumen role
psql "${psql_settings[@]}" -v --dbname "${POSTGRES_DB}" <<-EOSQL
  CREATE USER lumen WITH CREATEDB PASSWORD 'password';
EOSQL

## Create lumen dbs
psql_settings=("--username=lumen" "--host=localhost")
export PGPASSWORD="password"
psql "${psql_settings[@]}" -v --dbname "${POSTGRES_DB}" <<-EOSQL
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
psql_settings=("--username=${POSTGRES_USER}" "--host=localhost")
export PGPASSWORD=$POSTGRES_USER_PASSWORD


psql "${psql_settings[@]}" -v --dbname lumen --command "${EXTENSIONS}"

psql "${psql_settings[@]}" -v --dbname test_lumen --command "${EXTENSIONS}"


psql_settings=("--username=lumen" "--host=localhost")
export PGPASSWORD="password"

## Create tenants dbs
psql "${psql_settings[@]}" -v --dbname "${POSTGRES_DB}" <<-EOSQL

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

psql_settings=("--username=${POSTGRES_USER}" "--host=localhost")
export PGPASSWORD=$POSTGRES_USER_PASSWORD

## Create extensions for dbs
psql "${psql_settings[@]}" --dbname lumen_tenant_1 --command "${EXTENSIONS}"
psql "${psql_settings[@]}" --dbname lumen_tenant_2 --command "${EXTENSIONS}"
psql "${psql_settings[@]}" --dbname test_lumen_tenant_1 --command "${EXTENSIONS}"
psql "${psql_settings[@]}" --dbname test_lumen_tenant_2 --command "${EXTENSIONS}"

echo "----------"
echo "Done!"
