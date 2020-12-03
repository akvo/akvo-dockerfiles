#!/usr/bin/env bash

OLDER_GIT_VERSION=$1
NEWEST_GIT_VERSION=$2
MSG=$3
GITHUB_PROJECT=$6
ZULIP_STREAM=$7

cat << EOF > notify.team.sh
#!/usr/bin/env bash

if [ -z "\${ZULIP_CLI_TOKEN}" ]; then
  echo "You need a env var ZULIP_CLI_TOKEN with a valid Zulip API key"
  echo "See https://zulipchat.com/api/api-keys for instructions"
  echo "Create the env variable and rerun this script (\$0)"
  echo "Environment variable format is YOUR_EMAIL:API_KEY"
  exit 1
fi

zulip_txt=\$(git --no-pager log --reverse --oneline --no-merges $OLDER_GIT_VERSION..$NEWEST_GIT_VERSION | cut -f 2- -d\  | sed 's/\[#\([0-9]*\)\]/\[#\1\]\(https:\/\/github.com\/akvo\/${GITHUB_PROJECT}\/issues\/\1\)/' | tr \" \')

curl --request POST https://akvo.zulipchat.com/api/v1/messages \
    --user "\${ZULIP_CLI_TOKEN}" \
    --data "type=stream" \
    --data "to=${ZULIP_STREAM}" \
    --data "topic=Releases" \
    --data-urlencode "content=$MSG. [Full diff](https://github.com/akvo/${GITHUB_PROJECT}/compare/$OLDER_GIT_VERSION..$NEWEST_GIT_VERSION).

\${zulip_txt}"

EOF

chmod u+x notify.team.sh
