FROM akvo/akvo-run-as-user:20181023.473c11f as ras

FROM cypress/base:10

ENV CYPRESS_CACHE_FOLDER=/app

RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends \
    runit=2.1.2-9.2 && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --home /home/akvo --create-home --shell /bin/bash akvo && \
    mkdir /app && \
    \
    # Upgrade npm
    npm i -g npm

COPY --from=ras /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh
COPY package* /app/
COPY run.sh /usr/local/bin/run.sh

WORKDIR /app

RUN chown -R akvo:akvo /app && \
    su akvo -c 'npm i --silent cypress && npm run cypress:verify' && \
    rm -rf /home/akvo/.npm

ENTRYPOINT ["run-as-user.sh"]
