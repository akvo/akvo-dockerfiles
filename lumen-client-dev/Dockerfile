FROM akvo/akvo-run-as-user:20181023.473c11f as ras

FROM mhart/alpine-node:8

ENV APP_DIR=/lumen

COPY --from=ras /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh

# The base image is based on alpine:3.6 and
# does not have fussy versions
# https://github.com/hadolint/hadolint/issues/204#issuecomment-394103224
RUN set -ex; \
    apk add --no-cache \
    bash=4.3.48-r1 \
    build-base=0.5-r0 \
    cairo-dev=1.14.8-r0 \
    jpeg-dev=8-r6 \
    git=2.13.7-r1 \
    pango-dev=1.40.5-r0 \
    python2=2.7.15-r0 \
    runit=2.1.2-r3 \
    shadow=4.2.1-r11 \
    xz=5.2.3-r0 && \
    adduser -h /home/akvo -s /bin/bash -D akvo

WORKDIR /lumen

ENTRYPOINT ["run-as-user.sh"]

CMD ["./install-and-start.sh"]
