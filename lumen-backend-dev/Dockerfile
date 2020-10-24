FROM akvo/akvo-run-as-user:20200813.123605.7ae822d as runasuser

FROM clojure:lein-2.9.3-slim-buster
COPY --from=runasuser /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh

RUN set -eux; \
    apt-get update && \
    apt-get -qq install -y --no-install-recommends --no-install-suggests \
    postgis=2.5.1+dfsg-1 \
    gdal-bin=2.4.0+dfsg-1+b1 \
    postgresql-client-11=11.9-0+deb10u1 \
    runit=2.1.2-25 && \
    useradd --create-home --home /home/akvo --shell /bin/bash --password akvo akvo && \
    cp -r /root/.lein /home/akvo/.lein && \
    chown akvo:akvo /home/akvo/.lein -R && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
