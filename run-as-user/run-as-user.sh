#!/usr/bin/env bash

set -o errexit
set -o nounset

app_dir="${APP_DIR:=/app}"

host_uid=$(stat -c '%u' "${app_dir}")
host_gid=$(stat -c '%g' "${app_dir}")

user_home="/home/akvo"

if [[ "${host_uid}" -eq 0 ]]; then
    user_home="/root"
fi

groupmod -g "${host_gid}" -o akvo >/dev/null 2>&1
usermod -u "${host_uid}" -o akvo >/dev/null 2>&1

exec chpst -u akvo:akvo -U akvo:akvo env HOME="${user_home}" "$@"
