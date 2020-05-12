

OLDER_GIT_VERSION=$1
NEWEST_GIT_VERSION=$2
MSG=$3
COLOR=$4
WRAP_SLACK=$5
GITHUB_PROJECT=$6

cat << EOF > notify.team.sh
#!/usr/bin/env bash

if [ -z "\${SLACK_CLI_TOKEN}" ]; then
  echo "You need a env var SLACK_CLI_TOKEN with a Slack legacy token"
  echo "Go to https://api.slack.com/custom-integrations/legacy-tokens to create one"
  echo "Create the env variable and rerun this script (\$0)"
  exit 1
fi

slack_txt=\$(git log --oneline $OLDER_GIT_VERSION..$NEWEST_GIT_VERSION | grep -v "Merge pull request" | grep -v "Merge branch" | cut -f 2- -d\  | sed 's/\[#\([0-9]*\)\]/#\1/' | tr \" \' | tr \& \ )

curl -X POST https://akvo.zulipchat.com/api/v1/messages \
    -u dan@akvo.org:wOdkvwntYhHf2Ge4ag5sZdOMIoqJ0t1y \
    -d "type=stream" \
    -d "to=rsr" \
    -d "topic=Releases" \
    -d $"content=$MSG. [Full diff](https://github.com/akvo/${GITHUB_PROJECT}/compare/$OLDER_GIT_VERSION..$NEWEST_GIT_VERSION).

\$slack_txt"

EOF

chmod u+x notify.team.sh