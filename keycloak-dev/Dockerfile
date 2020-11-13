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
FROM jboss/keycloak:3.4.3.Final

COPY --from=build /opt/jboss/keycloak/standalone/data/keycloak.mv.db \
	/opt/jboss/keycloak/standalone/data/keycloak.mv.db
COPY --from=build /opt/jboss/keycloak/standalone/configuration/standalone.xml \
	/opt/jboss/keycloak/standalone/configuration/standalone.xml

CMD ["-b", "0.0.0.0"]
