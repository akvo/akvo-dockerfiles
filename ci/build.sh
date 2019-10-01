#!/usr/bin/env bash

set -eu

if [[ "${TRAVIS_PULL_REQUEST:=false}" != "false" ]]; then
    COMMIT_RANGE="FETCH_HEAD..${TRAVIS_BRANCH}"
    echo "travis PR #${TRAVIS_PULL_REQUEST} build, looking at files in ${COMMIT_RANGE}"
    COMMIT_CONTENT=$(git diff --name-only "${COMMIT_RANGE}")
else
    COMMIT_RANGE="${TRAVIS_COMMIT_RANGE/.../..}"
    echo "travis push build, looking at files in ${COMMIT_RANGE}"
    if [ "${COMMIT_RANGE}" == "" ]; then
      echo "travis commit range empty, probably first push to a new branch"
      COMMIT_CONTENT=$(git diff-tree --no-commit-id --name-only -r "${TRAVIS_COMMIT}")
    else
      COMMIT_CONTENT=$(git diff --name-only "${COMMIT_RANGE}") || {
        echo "travis commit range diff failed, probably new PR or force push, falling back to single commit ${TRAVIS_COMMIT}"
        COMMIT_CONTENT=$(git diff-tree --no-commit-id --name-only -r "${TRAVIS_COMMIT}")
      }
    fi
fi

echo "commits content: ${COMMIT_CONTENT}"

# Directories one level deep
DIRS=$(echo "${COMMIT_CONTENT}" | grep ".*/.*" | cut -f 1 -d/ | sort -u)

echo "Dirs to be build: ${DIRS}"

prefix=$(date +%Y%m%d.%H%M%S)
tag="${TRAVIS_COMMIT:=local}"
tag="${prefix}.${tag:0:7}"

while read -r folder; do
  (
	if [[ ! -d "${folder}" ]] || [[ ! -f "${folder}/Dockerfile" ]]; then
	    exit 0
	fi
	cd "${folder}"
	echo "Checking and building ${folder} ..."
	docker run --rm -i hadolint/hadolint < Dockerfile
	find . -name '*.sh' -exec shellcheck {} \;
	image_name="akvo/akvo-${folder}"
	docker build -t "${image_name}:${tag}" .

	## deploy
	if [[ "${TRAVIS_BRANCH}" != "master" ]]; then
    exit 0
  fi

  if [[ "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
        exit 0
  fi

  docker login -u="${DOCKERHUB_USERNAME}" -p="${DOCKERHUB_PASSWORD}"
	echo "Pushing ${image_name} ..."
	docker push "${image_name}"
	echo "Image name ${image_name}:${tag}"
  )
done <<< "${DIRS}"