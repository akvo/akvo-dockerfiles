#!/usr/bin/env bash

set -eu

CI_COMMIT="${SEMAPHORE_GIT_SHA:=local}"
CI_BRANCH="${SEMAPHORE_GIT_BRANCH:=unknown}"
PR_NUMBER="${SEMAPHORE_GIT_PR_NUMBER:=0}"
COMMIT_RANGE="${SEMAPHORE_GIT_COMMIT_RANGE:=}"

if [[ "${PR_NUMBER}" == "0" ]]; then
    CI_PULL_REQUEST="false"
else
    CI_PULL_REQUEST="true"
fi

# if [[ "${CI_PULL_REQUEST:=false}" != "false" ]]; then
#     COMMIT_RANGE="FETCH_HEAD..${CI_BRANCH}"
#     echo "travis PR #${} build, looking at files in ${COMMIT_RANGE}"
#     COMMIT_CONTENT=$(git diff --name-only "${COMMIT_RANGE}")
# else
#     COMMIT_RANGE="${TRAVIS_COMMIT_RANGE/.../..}"
#     echo "travis push build, looking at files in ${COMMIT_RANGE}"
#     if [ "${COMMIT_RANGE}" == "" ]; then
# 	echo "travis commit range empty, probably first push to a new branch"
# 	COMMIT_CONTENT=$(git diff-tree --no-commit-id --name-only -r "${TRAVIS_COMMIT}")
#     else
# 	COMMIT_CONTENT=$(git diff --name-only "${COMMIT_RANGE}") || {
#             echo "travis commit range diff failed, probably new PR or force push, falling back to single commit ${TRAVIS_COMMIT}"
#             COMMIT_CONTENT=$(git diff-tree --no-commit-id --name-only -r "${TRAVIS_COMMIT}")
# 	}
#     fi
# fi

COMMIT_CONTENT=$(git diff --name-only "${COMMIT_RANGE}")

echo "commits content: ${COMMIT_CONTENT}"

# Directories one level deep
DIRS=$(echo "${COMMIT_CONTENT}" | grep ".*/.*" | cut -f 1 -d/ | sort -u)

echo "Dirs to be build: ${DIRS}"

prefix=$(date +%Y%m%d.%H%M%S)
tag="${CI_COMMIT}"
tag="${prefix}.${tag:0:7}"

while read -r folder; do
    (
	if [[ ! -d "${folder}" ]] || [[ ! -f "${folder}/Dockerfile" ]]; then
	    exit 0
	fi
	cd "${folder}"
	echo "Checking and building ${folder} ..."
	docker run --rm -i hadolint/hadolint < Dockerfile
	find . -name '*.sh' -type f -print0 | xargs -0 -r -n1 shellcheck
	image_name="akvo/akvo-${folder}"
	docker build -t "${image_name}:${tag}" .

	## deploy
	if [[ "${CI_BRANCH}" != "master" ]]; then
	    exit 0
	fi

	if [[ "${CI_PULL_REQUEST}" != "false" ]]; then
            exit 0
	fi

	echo "Pushing ${image_name} ..."
	docker push "${image_name}"
	echo "Image name ${image_name}:${tag}"
    )
done <<< "${DIRS}"
