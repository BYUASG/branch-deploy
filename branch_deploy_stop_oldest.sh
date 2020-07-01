#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. $SCRIPT_DIR/branch_deploy.env

BRANCH_DIRECTORIES=$(ls -ltr $BRANCHES_DIR/ | grep -v $BRANCH_LIST_FILE | grep -vE "^total" )
echo "BRANCH_DIRECTORIES = $BRANCH_DIRECTORIES"
STOP_BRANCHES=$(echo "$BRANCH_DIRECTORIES" | head -n -$MAX_RUNNING_BRANCHES);

if [ "$STOP_BRANCHES" != "" ]; then
  while read -r LISTING; do
    THIS_DIR=$(echo "$LISTING" | awk '{print $(NF)}')
    THIS_BRANCH_DIR=$BRANCHES_DIR/$THIS_DIR
    echo checking $THIS_BRANCH_DIR

    cd $THIS_BRANCH_DIR
    if [ $(docker-compose ps | wc -l) -gt 2 ]; then
      # BRANCH_PORT just needst to be set, does not need to be to the correct value for this branch
      export BRANCH_PORT=$START_PORT
      docker-compose -f $DOCKER_COMPOSE_FILE down
    fi

  done <<< "$STOP_BRANCHES"
fi
