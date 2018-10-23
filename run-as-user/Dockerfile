FROM debian:stretch

RUN set -ex; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    runit=2.1.2-9.2 && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --create-home --home /home/akvo \
            --password akvo --shell /bin/bash akvo

COPY run-as-user.sh /usr/local/bin/run-as-user.sh
