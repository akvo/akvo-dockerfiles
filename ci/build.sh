#!/usr/bin/env bash

set -eu

modified=$(git diff-tree --no-commit-id --name-only -r "${TRAVIS_COMMIT}" | cut -d '/' -f1 | sort -u)
prefix=$(date +%Y%m%d.%H%M%S)
tag="${TRAVIS_COMMIT:=local}"
tag="${prefix}.${tag:0:7}"

for folder in ${modified}; do
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
    )
done
