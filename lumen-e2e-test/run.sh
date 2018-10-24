#!/usr/bin/env bash

set -o errexit
set -o nounset

echo "Running Cypress against ${CYPRESS_LUMEN_URL}"

if [[ -z "${CYPRESS_RECORD_KEY:=}" ]]; then
    npm run cypress:run -- --project /app/e2e-test
else
    npm run cypress:run -- --project /app/e2e-test --record
fi
