#!/usr/bin/env bash

# load our environment variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $SCRIPT_DIR
. $SCRIPT_DIR/env.sh

docker-compose up -d
