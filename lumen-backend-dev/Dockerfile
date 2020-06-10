FROM akvo/akvo-run-as-user:20181023.473c11f as runasuser

FROM clojure:openjdk-11-lein-2.9.3

COPY --from=runasuser /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh

RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    gdal-bin=2.4.0+dfsg-1+b1 \
    postgis=2.5.1+dfsg-1 \
    postgresql-client-11=11.7-0+deb10u1 \
    runit=2.1.2-25 && \
    useradd --create-home --home /home/akvo --shell /bin/bash --password akvo akvo && \
    cp -r /root/.lein /home/akvo/.lein && \
    chown akvo:akvo /home/akvo/.lein -R && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
