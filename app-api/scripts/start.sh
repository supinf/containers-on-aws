#!/bin/bash

# Generate docker-comose.yml
export AWS_ACCOUNT_ID=$( aws sts get-caller-identity --query "Account" --output text )
export AWS_REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
sudo sed -i -e 's/AWS_ACCOUNT_ID/'${AWS_ACCOUNT_ID}'/g' /tmp/docker-compose.yml
sudo sed -i -e 's/AWS_REGION/'${AWS_REGION}'/g' /tmp/docker-compose.yml

# Pull the latest docker image from ECR using its credential-helper
docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/demo/api:latest

# Start the process with docker-compose
docker-compose -f /tmp/docker-compose.yml up -d
