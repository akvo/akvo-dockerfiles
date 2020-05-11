FROM akvo/akvo-run-as-user:20181023.473c11f as runasuser

FROM kiwigrid/gcloud-kubectl-helm:2.12.3-234.0.0-88

USER root

RUN set -x \
    && apk add -u --no-cache curl jq bash \
    && curl -o /usr/bin/slack-cli https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack \
    && chmod +x /usr/bin/slack-cli \
    && slack-cli -v

COPY --from=runasuser /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh
COPY promote-test-to-prod.sh /usr/local/bin/promote-test-to-prod.sh
COPY helpers/generate-slack-notification.sh /usr/local/bin/generate-slack-notification.sh

USER gkh
WORKDIR /project