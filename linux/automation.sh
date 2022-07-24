#!/bin/bash -x

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

REVISION=`git rev-parse --short HEAD`

BRANCH=`git status |head -n 1|awk '{print $3}'`
DEPLOY_NAME="webserver"  #`basename $(git remote show -n origin | grep URL|head -1 | cut -d: -f2-)|awk -F '.' '{print $1}'`
# Docker username or ecr or digitalocean repo name
DOCKER_REPO_URL="myrepousername"


echo "${GREEN}Start Build${NC}"
echo "Deploy Name: $DEPLOY_NAME"
echo "Branch: $BRANCH"
echo "Rev: $REVISION"
docker build -f ./frontend/Dockerfile -t $DOCKER_REPO_URL/${DEPLOY_NAME}_frontend:prod ./frontend
docker build -f ./backend/Dockerfile -t $DOCKER_REPO_URL/${DEPLOY_NAME}_api:prod ./backend

# Push to repo
echo "${GREEN}Push Docker IMAGE Build ${NC}"
echo "Deploy Name: $DEPLOY_NAME"
echo "Branch: $BRANCH"
echo "Rev: $REVISION"
docker push $DOCKER_ECR_REPO_URL/$DEPLOY_NAME:$BRANCH-$REVISION

#Generate new_app.yaml file for deployment
printf "%sGenerate New Yaml file%s\n" "$GREEN" "$NC"
echo "Deploy Name: $DEPLOY_NAME"
echo "Branch: $BRANCH"
echo "Rev: $REVISION"
cat script.yaml  > new_app.yaml
sed -i"" "s~{{MY_NEW_IMAGE}}~$DOCKER_ECR_REPO_URL/$DEPLOY_NAME:$BRANCH-$REVISION~" new_app.yaml

#compare diff
kubectl diff -f ./new_app.yaml

