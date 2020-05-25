FROM kiwigrid/gcloud-kubectl-helm:2.12.3-234.0.0-88

# hadolint ignore=DL3002
USER root

RUN set -x \
    && apk add -u --no-cache curl~=7 jq~=1 bash~=4 shadow~=4.5 runit~=2.1 \
    && curl -o /usr/bin/slack-cli https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack \
    && chmod +x /usr/bin/slack-cli \
    && slack-cli -v

RUN useradd --create-home --home /home/akvo --shell /bin/bash --password akvo akvo
COPY run-as-user.sh /usr/local/bin/run-as-user.sh
COPY promote-test-to-prod.sh /usr/local/bin/promote-test-to-prod.sh
COPY helpers/generate-slack-notification.sh /usr/local/bin/generate-slack-notification.sh
COPY helpers/generate-zulip-notification.sh /usr/local/bin/generate-zulip-notification.sh

COPY flow/flip-production-traffic.sh /usr/local/bin/flow-flip-production-traffic.sh
COPY flow/promote-test-to-prod.sh /usr/local/bin/flow-promote-test-to-prod.sh

WORKDIR /app
ENTRYPOINT ["/usr/local/bin/run-as-user.sh"]