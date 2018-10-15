#FROM cypress/base:8
FROM cypress/base@sha256:740d461c0da849543a5b67611a426e8807263efe6cb0251e6e5feddc4288e3b0

RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends \
    runit=2.1.2-3 && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -d /home/akvo -m -s /bin/bash akvo && \
    mkdir /app && \
    \
    # Upgrade npm
    npm i -g npm

COPY package* /app/
COPY *.sh /usr/local/bin/

WORKDIR /app

RUN chown -R akvo:akvo /app && \
    su akvo -c 'npm i --silent cypress && npm run cypress:verify'

CMD ["run.sh"]
