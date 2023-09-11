#!/bin/bash

# exit when any command fails
set -e

new_ver=$1

echo "new version: $new_ver"

# Simulate release of the new docker images
docker tag nginx:1.23.3 aminbenmansour/webapp:$new_ver

# Push new version to dockerhub
docker push aminbenmansour/webapp:$new_ver

# Create temporary folder
tmp_dir=$(mktemp -d)
echo $tmp_dir

# Clone GitHub repo
git clone git@github.com:aminbenmansour/reg-poc-webapp.git $tmp_dir

# Update image tag
sed -i '' -e "s/aminbenmansour\/webapp:.*/aminbenmansour\/webapp:$new_ver/g" $tmp_dir/k8s/3-deployment.yaml

# Commit and push
cd $tmp_dir
git add .
git commit -m "Update image to $new_ver"
git push

# Optionally on build agents - remove folder
rm -rf $tmp_dir