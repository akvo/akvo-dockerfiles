#!/usr/bin/env bash

set -u

function log {
   echo "$(date +"%T") - INFO - $*"
}

DEPLOYMENT_NAME=$1
DEPLOYMENT_VERSION_LABEL=$2
GITHUB_PROJECT=$3
NOTIFICATION=$4
ZULIP_STREAM=$5
COMMIT_HASH=${6:-}  # Don't query the test environment, just try and deploy the given commit

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

if [[ -z "$(gcloud config list --format='value(core.account)')" ]]; then
  gcloud auth login
fi

gcloud config set project akvo-lumen


read_version "production"
PROD_VERSION=$VERSION

if [[ -z "${COMMIT_HASH}" ]] ; then
  read_version "test"
  TEST_VERSION=$VERSION
  log "Deployed test version is $TEST_VERSION"
else
  TEST_VERSION=$COMMIT_HASH
  log "Version to deploy is $TEST_VERSION"
fi
log "Deployed prod version is $PROD_VERSION"
log "See https://github.com/akvo/${GITHUB_PROJECT}/compare/$PROD_VERSION..$TEST_VERSION"

log "Commits to be deployed:"
echo ""
git --no-pager log --reverse --oneline --no-merges "${PROD_VERSION}..${TEST_VERSION}"

"generate-${NOTIFICATION}-notification.sh" "${PROD_VERSION}" "${TEST_VERSION}" "I am thinking about deploying **${GITHUB_PROJECT}** to production. Should I?" "warning" "dont_wrap" "$GITHUB_PROJECT" "$ZULIP_STREAM"
./notify.team.sh

TAG_NAME="promote-$(TZ=UTC date +"%Y%m%d-%H%M%S")"

echo ""
read -r -e -p "Does this deployment contain a hotfix, rollback or fix-forward for a previous deployment? [Y/n] " FIX
if [ "${FIX}" != "n" ] && [ "${FIX}" != "N" ]; then
   PROMOTION_REASON="FIX_RELEASE"
else
   PROMOTION_REASON="REGULAR_RELEASE"
fi

"generate-${NOTIFICATION}-notification.sh" "${PROD_VERSION}" "${TEST_VERSION}" "Promoting **${GITHUB_PROJECT} to production** cluster" "warning" "wrap_slack" "$GITHUB_PROJECT" "$ZULIP_STREAM"

log "To deploy, run: "
echo "----------------------------------------------"
echo "git tag -a $TAG_NAME $TEST_VERSION -m \"$PROMOTION_REASON\""
echo "git push origin $TAG_NAME"
echo "./notify.team.sh"
echo "----------------------------------------------"
