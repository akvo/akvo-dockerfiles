FROM akvo/akvo-postgres-9.6:20181016.51e1148 as akvo-pg

FROM mdillon/postgis:9.6 as mdillon

COPY --from=akvo-pg /docker-entrypoint-initdb.d/*.sh /docker-entrypoint-initdb.d/
COPY z-init.sh /docker-entrypoint-initdb.d/z-init.sh
