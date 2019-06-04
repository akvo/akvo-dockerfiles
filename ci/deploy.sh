#!/usr/bin/env bash

set -eu

if [[ "${TRAVIS_BRANCH}" != "master" ]]; then
    exit 0
fi

if [[ "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    exit 0
fi

docker login -u="${DOCKERHUB_USERNAME}" -p="${DOCKERHUB_PASSWORD}"

modified=$(git diff-tree --no-commit-id --name-only -r "${TRAVIS_COMMIT}" | cut -d '/' -f1 | sort -u)

for folder in ${modified}; do
    (
	if [[ ! -d "${folder}" ]] || [[ ! -f "${folder}/Dockerfile" ]]; then
	    exit 0
	fi
	image_name="akvo/akvo-${folder}"
	echo "Pushing ${image_name} ..."
	docker push "${image_name}"
    )
done
