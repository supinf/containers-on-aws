#!/bin/bash

set -e
sleep 5

# Generate docker-comose.yml
export AWS_ACCOUNT_ID=$( aws sts get-caller-identity --query "Account" --output text )
export AWS_REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
sudo sed -i -e 's/AWS_ACCOUNT_ID/'${AWS_ACCOUNT_ID}'/g' /tmp/docker-compose.yml
sudo sed -i -e 's/AWS_REGION/'${AWS_REGION}'/g' /tmp/docker-compose.yml

# Stop the process
docker-compose -f /tmp/docker-compose.yml stop
docker-compose -f /tmp/docker-compose.yml rm -f

# Remove the latest docker image
docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/demo/api:latest 2>/dev/null || true
