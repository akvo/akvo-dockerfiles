FROM akvo/akvo-run-as-user:20181023.473c11f as ras

FROM cypress/included:3.8.1

RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends \
    runit=2.1.2-9.2 && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --home /home/akvo --create-home --shell /bin/bash akvo && \
    mkdir /app && \
    chown -R akvo:akvo /app

COPY --from=ras /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh
COPY run.sh /usr/local/bin/run.sh

WORKDIR /app

ENTRYPOINT ["run-as-user.sh"]
