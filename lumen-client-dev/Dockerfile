FROM akvo/akvo-run-as-user:20181023.473c11f as ras

FROM mhart/alpine-node:12.19.0

ENV APP_DIR=/lumen

COPY --from=ras /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh

RUN set -ex; \
    apk add --no-cache \
    bash=~4 \
    build-base=~0.5 \
    cairo-dev=~1.16 \
    jpeg-dev=~8 \
    git=~2 \
    pango-dev=~1.42 \
    python2=~2.7 \
    runit=~2 \
    shadow=~4.5 \
    xz=~5.2 && \
    adduser -h /home/akvo -s /bin/bash -D akvo

WORKDIR /lumen

ENTRYPOINT ["run-as-user.sh"]

CMD ["./install-and-start.sh"]
