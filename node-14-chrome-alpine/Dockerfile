FROM akvo/akvo-run-as-user:20200813.123605.7ae822d as runasuser

FROM zenika/alpine-chrome:89-with-puppeteer
COPY --from=runasuser /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh

USER root
RUN set -ex; \
    apk add --no-cache \
    bash~=5 \
    runit~=2 \
    shadow~=4 && \
    adduser -D -h /home/akvo -s /bin/bash akvo akvo
USER guest

ENTRYPOINT ["run-as-user.sh"]
