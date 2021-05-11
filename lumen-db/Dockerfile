FROM akvo/akvo-postgres-10.16:20210511.081050.71eb33c as akvo-pg

FROM mdillon/postgis:10 as mdillon

COPY --from=akvo-pg /docker-entrypoint-initdb.d/*.sh /docker-entrypoint-initdb.d/
COPY z-init.sh /docker-entrypoint-initdb.d/z-init.sh
