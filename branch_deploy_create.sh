#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. $SCRIPT_DIR/branch_deploy.env

# Generate port number
#    this could be done easier (maybe) and more threadsafe (definitely) with a real database of some sort
touch $BRANCH_LIST
if ! grep -qcE "^$BRANCH " $BRANCH_LIST; then
  # Port is selected as $START_PORT + the number of lines in the branch list
  echo $BRANCH $((START_PORT + $(wc -l < $BRANCH_LIST))) $BRANCH_SUBDOMAIN >> $BRANCH_LIST
fi

# Get port number for branch
export BRANCH_PORT=$(grep -E "^$BRANCH " $BRANCH_LIST | cut -d' ' -f2)

echo Deploying $BRANCH to $BRANCH_DIR on $BRANCH_PORT

# Clean up previous deploy of this branch if it exists
$SCRIPT_DIR/branch_deploy_remove.sh $BRANCH

# This may not be needed in CI, but just for testing lets make sure we're on the right branch
# Depending upon the enviornment you may even want to `git clean -fd`
cd $CODE_DIR
git checkout $BRANCH

# Copy the code to the branch dir, this could be done with something like git archive | tar -x too
mkdir -p $BRANCH_DIR
rsync -av --progress $CODE_DIR/ $BRANCH_DIR --exclude .git

# Launch our containter(s), keeping in mind we 'exported' the BRANCH_PORT variable above
cd $BRANCH_DIR
docker-compose -f $DOCKER_COMPOSE_FILE up --build -d

# And... how'd we do?
if [ "$?" == 0 ] ; then
  echo;echo "$BRANCH deployed successfully to port $BRANCH_PORT";echo
else
  echo "Error bringing containers online, probably should have some better error handing here."
fi

# this is a bit lazy, we may want to run this with n-1 at the beginnung of this
#   script if the goal is to be sure to always cap the number of running branches
$SCRIPT_DIR/branch_deploy_stop_oldest.sh

if [ "$NGINX_PROXY" == "subdomain" ]; then
  echo Deploying Nginx Reverse Proxy on port $NGINX_PORT
  $SCRIPT_DIR/nginx-proxy/create-config.sh
fi
