FROM google/cloud-sdk:272.0.0

RUN set -eux; \
    apk --no-cache add \
    bash~=5.0 \
    git~=2 \
    jq~=1.6 \
    unzip~=6 \
    openjdk8~=8 \
    parallel \
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
