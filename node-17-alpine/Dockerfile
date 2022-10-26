FROM akvo/akvo-run-as-user:20200813.123605.7ae822d as runasuser

FROM node:17.3.0-alpine3.15
COPY --from=runasuser /usr/local/bin/run-as-user.sh /usr/local/bin/run-as-user.sh

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache \
    python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

RUN set -ex; \
    apk add --no-cache \
    bash~=5 \
    runit~=2 \
    shadow~=4 && \
    adduser -D -h /home/akvo -s /bin/bash akvo akvo

ENTRYPOINT ["run-as-user.sh"]
