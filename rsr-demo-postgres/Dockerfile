FROM bitnami/postgresql:9.6.13-r28

USER root

RUN set -ex; apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    jq=1.* \
    lzop=1.* \
    && rm -rf /var/lib/apt/lists/*

USER 1001
