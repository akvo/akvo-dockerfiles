#!/usr/bin/env bash

set -u

function log {
   echo "$(date +"%T") - INFO - $*"
}

function read_version () {
    PROJECT=$1
    log "Reading ${PROJECT} version"
    VERSION=$(gcloud app versions list --project="${PROJECT}" --hide-no-traffic --service=default --format="value(VERSION)")
}

GITHUB_PROJECT=akvo-flow

PROD_CLUSTER="akvoflow-internal2"

read_version $PROD_CLUSTER
PROD_LIVE_VERSION=$VERSION
read_version "akvoflow-uat1"
PROD_DARK_VERSION=$VERSION

if [[ "${PROD_LIVE_VERSION}" == "${PROD_DARK_VERSION}" ]]; then
  log "Production is already running the same version as UAT1. Probably you are trying to perform a rollback."
  DEFAULT_VERSION_TO_FLIP_TO=""
else
  log "Guessing new version is UAT1 version: $PROD_DARK_VERSION"
  DEFAULT_VERSION_TO_FLIP_TO=$PROD_DARK_VERSION
fi

log "Deployed versions in production: "
gcloud app versions list --project="$PROD_CLUSTER" --sort-by=~VERSION.createTime --limit=5

read -r -e -p "Which version do you want to flip the traffic to? [$DEFAULT_VERSION_TO_FLIP_TO]" NEW_LIVE_VERSION
if [[ -z "$NEW_LIVE_VERSION" ]]; then
  NEW_LIVE_VERSION=$DEFAULT_VERSION_TO_FLIP_TO
fi

if ! gcloud app versions list --project="$PROD_CLUSTER" --sort-by=~VERSION.createTime --limit=5 --format="value(VERSION)" | grep "^${NEW_LIVE_VERSION}"; then
  log "Version selected [$NEW_LIVE_VERSION] not deployed in production. Doing nothing."
  exit 1
fi

log "Changes to be deployed: https://github.com/akvo/${GITHUB_PROJECT}/compare/$PROD_LIVE_VERSION..$NEW_LIVE_VERSION"
log "Commits to be deployed:"
git --no-pager log --oneline --no-merges "$PROD_LIVE_VERSION".."$NEW_LIVE_VERSION"

generate-zulip-notification.sh "${PROD_LIVE_VERSION}" "${NEW_LIVE_VERSION}" "I am thinking about flipping **FLOW prod** to make this changes live. Should I?" "warning" "not_wrap_slack" "$GITHUB_PROJECT" "K2 Engine"
./notify.team.sh

generate-zulip-notification.sh "${PROD_LIVE_VERSION}" "${NEW_LIVE_VERSION}" "Flipping *FLOW PROD!!!*" "warning" "wrap_slack" "$GITHUB_PROJECT" "K2 Engine"

TAG_NAME="flip-$(TZ=UTC date +"%Y%m%d-%H%M%S")"

log "To flip, run: "
echo "----------------------------------------------"
echo "git tag $TAG_NAME $NEW_LIVE_VERSION"
echo "git push origin $TAG_NAME"
echo "./notify.team.sh"
echo "----------------------------------------------"