#!/usr/bin/env bash

# load our environment variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $SCRIPT_DIR
. $SCRIPT_DIR/env.sh

# parse the name of the running container
CONTAINER_NAME=$(docker-compose ps | tail -n 1 | cut -d" " -f 1)

echo reloading nginx config on $CONTAINER_NAME

docker exec $CONTAINER_NAME nginx -s reload
