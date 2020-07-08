#!/usr/bin/env bash

# load our environment variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $SCRIPT_DIR
. $SCRIPT_DIR/env.sh

export NETWORK_NAME

rm nginx.conf.d/branch-*.conf

# This uses the age of the branch directories to see which ones should be live.
# This could be made more robust by putting an actual DB behind the scripts.
BRANCH_DIRECTORIES=$(ls -ltr $BRANCHES_DIR/ | grep -v $BRANCH_LIST_FILE | grep -vE "^total" )
LIVE_BRANCHES=$(echo "$BRANCH_DIRECTORIES" | tail -n -$MAX_RUNNING_BRANCHES);

if [ "$LIVE_BRANCHES" != "" ]; then
  while read -r LISTING; do
    # Get port number for branch
    export BRANCH_SUBDOMAIN=$(echo "$LISTING" | awk '{print $(NF)}')
    export BRANCH_PORT=$(grep -E " $BRANCH_SUBDOMAIN$" $BRANCH_LIST | cut -d' ' -f2)
    echo $BRANCH_SUBDOMAIN $BRANCH_PORT

    echo "$(envsubst < nginx-branch.conf)" > nginx.conf.d/branch-$BRANCH_SUBDOMAIN.conf
  done <<< "$LIVE_BRANCHES"
fi
