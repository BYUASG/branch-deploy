#!/usr/bin/env bash

# load our environment variables
. env.sh

# parse the name of the running container
CONTAINER_NAME=$(docker-compose ps | tail -n 1 | cut -d" " -f 1)

echo reloading nginx config on $CONTAINER_NAME

docker exec $CONTAINER_NAME nginx -s reload
