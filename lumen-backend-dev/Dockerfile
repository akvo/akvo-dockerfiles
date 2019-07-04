FROM akvo/akvo-run-as-user:20181023.473c11f as ras

FROM clojure:lein-2.9.1

COPY --from=ras /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh

RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    gdal-bin=2.1.2+dfsg-5 \
    postgis=2.3.1+dfsg-2 \
    postgresql-client-9.6=9.6.13-0+deb9u1\
    runit=2.1.2-9.2 && \
    useradd --create-home --home /home/akvo --shell /bin/bash --password akvo akvo && \
    cp -r /root/.lein /home/akvo/.lein && \
    chown akvo:akvo /home/akvo/.lein -R && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
