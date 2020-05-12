#!/usr/bin/env bash

set -u

function log {
   echo "$(date +"%T") - INFO - $*"
}

DEPLOYMENT_NAME=$1
DEPLOYMENT_VERSION_LABEL=$2
GITHUB_PROJECT=$3

function read_version () {
    CLUSTER=$1
    log "Reading ${CLUSTER} version"
    log "running: gcloud container clusters get-credentials ${CLUSTER} --zone europe-west1-d --project akvo-lumen"
    if ! gcloud container clusters get-credentials "${CLUSTER}" --zone europe-west1-d --project akvo-lumen; then
        log "Could not change context to ${CLUSTER}. Nothing done."
        exit 3
    fi

    VERSION=$(kubectl get deployments "$DEPLOYMENT_NAME" -o jsonpath="{@.spec.template.metadata.labels['${DEPLOYMENT_VERSION_LABEL}']}")
}

read_version "test"
TEST_VERSION=$VERSION

read_version "production"
PROD_VERSION=$VERSION

log "Deployed test version is $TEST_VERSION"
log "Deployed prod version is $PROD_VERSION"
log "See https://github.com/akvo/${GITHUB_PROJECT}/compare/$PROD_VERSION..$TEST_VERSION"

log "Commits to be deployed:"
echo ""
git log --oneline --no-merges $PROD_VERSION..$TEST_VERSION

generate-slack-notification.sh "${PROD_VERSION}" "${TEST_VERSION}" "I am thinking about deploying ${GITHUB_PROJECT} to production. Should I?" "warning" "dont_wrap" "$GITHUB_PROJECT"
./notify.slack.sh

TAG_NAME="promote-$(date +"%Y%m%d-%H%M%S")"

echo ""
read -r -e -p "Does this deployment contain a hotfix, rollback or fix-forward for a previous deployment? [yn] " FIX
if [ "${FIX}" != "n" ]; then
   PROMOTION_REASON="FIX_RELEASE"
else
   PROMOTION_REASON="REGULAR_RELEASE"
fi

generate-slack-notification.sh "${PROD_VERSION}" "${TEST_VERSION}" "Promoting ${GITHUB_PROJECT} to production cluster" "warning" "wrap_slack" "$GITHUB_PROJECT"

log "To deploy, run: "
echo "----------------------------------------------"
echo "git tag -a $TAG_NAME $TEST_VERSION -m \"$PROMOTION_REASON\""
echo "git push origin $TAG_NAME"
echo "./notify.slack.sh"
echo "----------------------------------------------"