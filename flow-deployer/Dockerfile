FROM google/cloud-sdk:272.0.0-alpine

RUN set -eux; \
    apk add --no-cache \
    bash~=5 \
    git~=2 \
    jq~=1.6 \
    unzip~=6 \
    openjdk8~=8 \
    parallel~=20190522 \
    nss~=3.44

RUN gcloud components install app-engine-java --quiet && \
    rm -rf /google-cloud-sdk/.install/.backup && \
    rm -rf /google-cloud-sdk/.install/.download \
    \
# Disable annoying citation warning
    mkdir -p /home/root/.parallel && \
    touch /home/akvo/.parallel/will-cite

COPY deploy.sh /usr/loca/bin/deploy.sh

CMD ["/usr/loca/bin/deploy.sh"]
