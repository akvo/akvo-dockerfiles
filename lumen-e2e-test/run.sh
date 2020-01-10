#!/usr/bin/env bash

set -o errexit
set -o nounset

echo "Running Cypress against ${CYPRESS_LUMEN_URL}"

if [[ -z "${CYPRESS_RECORD_KEY:=}" ]]; then
    cypress run --project /app/e2e-test --browser chrome
else
    cypress run --project /app/e2e-test --record --browser chrome
fi
