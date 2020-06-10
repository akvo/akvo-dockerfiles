#!/usr/bin/env bash

OLDER_GIT_VERSION=$1
NEWEST_GIT_VERSION=$2
MSG=$3
GITHUB_PROJECT=$6

cat << EOF > notify.team.sh
#!/usr/bin/env bash

if [ -z "\${ZULIP_CLI_TOKEN}" ]; then
  echo "You need a env var ZULIP_CLI_TOKEN with a valid Zulip API key"
  echo "See https://zulipchat.com/api/api-keys for instructions"
  echo "Create the env variable and rerun this script (\$0)"
  echo "Environment variable format is YOUR_EMAIL:API_KEY"
  exit 1
fi

slack_txt=\$(git log --oneline $OLDER_GIT_VERSION..$NEWEST_GIT_VERSION | grep -v "Merge pull request" | grep -v "Merge branch" | cut -f 2- -d\  | sed 's/\[#\([0-9]*\)\]/#\1/' | tr \" \' | tr \& \ )

curl -X POST https://akvo.zulipchat.com/api/v1/messages \
    -u "\${ZULIP_CLI_TOKEN}" \
    -d "type=stream" \
    -d "to=rsr" \
    -d "topic=Releases" \
    -d "content=$MSG. [Full diff](https://github.com/akvo/${GITHUB_PROJECT}/compare/$OLDER_GIT_VERSION..$NEWEST_GIT_VERSION).

\$slack_txt"

EOF

chmod u+x notify.team.sh
