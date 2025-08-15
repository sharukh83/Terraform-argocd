#!/bin/bash

set -e

new_ver=$1
echo "new version is upgraded: $new_ver"

#docker pull sharukh8686/static-website1

docker tag  sharukh8686/static-website1 sharukh8686/static-website1:$new_ver

docker push sharukh8686/static-website1:$new_ver

temp_dir=$(mktemp -d)

echo $temp_dir

git clone https://github.com/sharukh83/Terraform-argocd.git $temp_dir

sed -i -e "s/sharukh8686\/static-website1:.*/sharukh8686\/static-website1:$new_ver/g" "$temp_dir/my-app/deployment.yaml"
#sed -i -e "s|sharukh8686/static-website1:.*|sharukh8686/static-website1:${new_ver}|g" $temp_dir/my-app/deployment.yaml
# Commit and push
cd $temp_dir
git add .
git commit -m "Update image to $new_ver"
git push

# Optionally on build agents - remove folder
rm -rf $temp_dir

