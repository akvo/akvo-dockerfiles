FROM google/cloud-sdk:322.0.0-alpine

ENV LEIN_ROOT=1
ENV CLOUDSDK_PYTHON_SITEPACKAGES=1

RUN set -ex ; \
    apk add --no-cache \
    bash~=5 \
    fontconfig~=2 \
    nodejs~=12 \
    npm~=12 \
    openjdk8~=8 \
    openssh-client~=8 \
    py-openssl~=19 \
    maven~=3 \
    shadow~=4 \
    su-exec~=0.2 \
    ttf-dejavu~=2 \
    uchardet~=0.0 \
    zip~=3 && \
    gcloud components install app-engine-java && \
    rm -rf /google-cloud-sdk/.install/.backup && \
    curl -L -o /usr/local/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod a+x /usr/local/bin/lein && \
    lein && \
    adduser -D -h /home/akvo -s /bin/bash akvo akvo

WORKDIR /app/src
