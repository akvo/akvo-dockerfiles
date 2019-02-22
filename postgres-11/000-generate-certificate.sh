#!/bin/bash

set -eu

PASSPHRASE="changeit"
SUB="/C=NL/ST=North Holland/L=Amsterdam/O=Akvo/CN=postgres"

cd "${PGDATA:=/var/lib/postgresql/data}"

openssl req -new -text -out server.req -passout "pass:${PASSPHRASE}" -subj "${SUB}"
openssl rsa -in privkey.pem -passin "pass:${PASSPHRASE}" -out server.key
openssl req -x509 -in server.req -text -key server.key -out server.crt -days 365

chmod 600 server.*

rm -rf privkey.pem server.req
