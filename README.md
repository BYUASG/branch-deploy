# Branch Deploy

This is a collection of shell scripts used to automatically deploy development
branches of a docker-compose project via a CI pipeline.  This will allow your
team to preview code to stakeholders or users before merging allowing for earlier
testing and feedback.


## Usage

Review `branch_deploy.env` at a minimum you'll want to update the location of
the clone of your repo (`$CODE_DIR`) so the script knows what code it's deploying.

In addition review the location the scripts should create a directory for the
code for each branch.

The scripts can be deployed on your CI server, cloned from a fork during the
deploy process or just added to a subdirectory of your main repo.

To invoke the script just call `./branch_deploy_create.sh $BRANCH_NAME` from your
CI pipelne where `$BRANCH_NAME` is the value of the branch you wish to deploy.
Probably the branch that has most recently been pushed/updated.
