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


## Reverse Proxy

To deploy branches by subdomain you'll want to configure the Reverse Proxy
section in branch_deploy.env

Setting NGINX_PROXY to subdomain will attempt to create an nginx container that
will use your branch name as a subdomain on your configured network NETWORK_NAME
listening on port NGINX_PORT.

For example, a branch named my_feature, on a network of example.test and NGINX_PORT
8080 will be accessible at http://my-feature.example.test:8080


## Next steps

* Better documentation and examples
* Implement optional path based reverse proxy
* Make subdomain name creation a little more robust (currently doesnt check for
  branch names that might result in subdomains ending or beggingn with -)
* Add a better, more robust database
