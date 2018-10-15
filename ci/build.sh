#!/usr/bin/env bash

set -eu

modified=$(git diff-tree --no-commit-id --name-only -r "${TRAVIS_COMMIT}" | cut -d '/' -f1 | sort -u)
prefix=$(date +%Y%m%d)
tag="${TRAVIS_COMMIT:=local}"
tag="${prefix}.${tag:0:7}"

for folder in ${modified}; do
    (
	if [[ ! -d "${folder}" ]] || [[ ! -f "${folder}/Dockerfile" ]]; then
	    exit 0
	fi
	cd "${folder}"
	echo "Building ${folder} ..."
	image_name="akvo/akvo-${folder}"
	docker build -t "${image_name}:${tag}" .
    )
done
