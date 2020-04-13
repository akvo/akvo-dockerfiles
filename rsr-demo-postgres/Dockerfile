FROM bitnami/postgresql:9.6.13-r28

USER root

RUN set -ex; \
    apt-get update && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" >> /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        apt-transport-https=1.* \
        ca-certificates=2* \
        gnupg=2.* && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -  && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    jq=1.* \
    lzop=1.* \
    google-cloud-sdk=288.* \
    && rm -rf /var/lib/apt/lists/*

USER 1001
