FROM akvo/akvo-run-as-user:20200813.123605.7ae822d as runasuser
FROM python:3.8.18-alpine3.18 as python

FROM node:18.20.7-alpine3.20
COPY --from=runasuser /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh
COPY --from=python /usr/local/bin/python3 /usr/local/bin/python
COPY --from=python /usr/local/lib/python3.8 /usr/local/lib/python3.8
COPY --from=python /usr/local/lib/libpython3.8.so.1.0 /usr/local/lib/libpython3.8.so.1.0
COPY --from=python /usr/local/lib/libpython3.so /usr/local/lib/libpython3.so

RUN set -ex; \
    apk --update add --no-cache \
    bash~=5 \
    g++~=13 \
    gcc~=13 \
    make~=4 \
    musl-dev~=1 \
    runit~=2 \
    shadow~=4 && \
    adduser -D -h /home/akvo -s /bin/bash akvo akvo

ENTRYPOINT ["run-as-user.sh"]