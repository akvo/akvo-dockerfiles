FROM akvo/akvo-run-as-user:20200813.123605.7ae822d as runasuser

FROM clojure:openjdk-11-lein-2.9.5-slim-buster
COPY --from=runasuser /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh

RUN set -eux; \
    apt-get update && \
    apt-get -qq install -y --no-install-recommends --no-install-suggests \
    fontconfig=2.13.1-2 \
    runit=2.1.2-25 \
    ttf-dejavu=2.37-1 && \
    useradd --create-home --home /home/akvo --shell /bin/bash --password akvo akvo && \
    cp -r /root/.lein /home/akvo/.lein && \
    chown akvo:akvo /home/akvo/.lein -R && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENTRYPOINT ["run-as-user.sh"]
