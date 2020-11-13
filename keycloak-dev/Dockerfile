# Original
FROM jboss/keycloak:3.4.3.Final as base

# Build
FROM jboss/keycloak:3.4.3.Final as build

COPY akvo.json /tmp/akvo.json
COPY manual-migration.cli /tmp/manual-migration.cli

USER jboss

WORKDIR /opt/jboss/keycloak

ENV JAVA_OPTS="-server -Xms64m -Xmx512m"

RUN set -ex; \
    bash ./bin/jboss-cli.sh --file=/tmp/manual-migration.cli

# Runtime
FROM adoptopenjdk/openjdk8:jre8u272-b10-alpine

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
ENV KEYCLOAK_VERSION 3.4.3.Final
EXPOSE 8080

RUN set -ex; \
    apk add --no-cache bash=~5 && \
    addgroup -g 1000 jboss && \
    adduser -h /opt/jboss -s /bin/bash -G jboss -u 1000 -D jboss && \
    chown 755 /opt/jboss

COPY --from=base /opt/jboss/keycloak/ /opt/jboss/keycloak/

COPY --from=build /opt/jboss/keycloak/standalone/data/keycloak.mv.db \
	/opt/jboss/keycloak/standalone/data/keycloak.mv.db

COPY --from=build /opt/jboss/keycloak/standalone/configuration/standalone.xml \
	/opt/jboss/keycloak/standalone/configuration/standalone.xml

RUN set -ex; chown jboss:jboss /opt/jboss/keycloak/ -R

USER jboss

WORKDIR /opt/jboss/keycloak

ENTRYPOINT ["/opt/jboss/keycloak/bin/standalone.sh"]

CMD ["-b", "0.0.0.0"]
