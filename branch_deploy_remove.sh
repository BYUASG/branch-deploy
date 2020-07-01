#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. $SCRIPT_DIR/branch_deploy.env

# Clean up previous deploy of this branch if it exists

if [ -d $BRANCH_DIR ]; then
  cd $BRANCH_DIR
  # BRANCH_PORT just needst to be set, does not need to be to the correct value for this branch
  export BRANCH_PORT=$START_PORT
  docker-compose -f $DOCKER_COMPOSE_FILE down
  cd ..
  echo removing $BRANCH_DIR
  rm -rf $BRANCH_DIR
fi
