#!/bin/bash

# If any of this commands fail, stop script.
set -e

# Set AWS access keys.
# This is required so that both aws-cli and ecs-cli can access you account
# programmatically. You should have both AWS_ACCESS_KEY_ID and
# AWS_SECRET_ACCESS_KEY from when we created the admin user.
# AWS_DEFAULT_REGION is the code for the aws region you chose, e.g., eu-west-2.
AWS_ACCESS_KEY_ID=AKIAIFNYABN4XZZWP4TA
AWS_SECRET_ACCESS_KEY=xENKyBUKwpluYqdvRocuwAdJwNpjVMP9XGd+8gON
AWS_DEFAULT_REGION=eu-central-1
PROFILE_NAME=grisplasp-eu

# Set AWS ECS vars.
# Here you only need to set AWS_ECS_URL. I have created the others so that
# it's easy to change for a different project. AWS_ECS_URL should be the
# base url.
AWS_ECS_URL=964858913990.dkr.ecr.eu-central-1.amazonaws.com
AWS_ECS_PROJECT_NAME=webserver
AWS_ECS_CONTAINER_NAME=grisplasp
AWS_ECS_DOCKER_IMAGE=grisplasp:latest
AWS_ECS_CLUSTER_NAME=grisplasp-eu-central-1


# Set runtime ENV.
# These are the runtime environment variables.
NODE_NAME=server1
HOST=ec2-18-185-18-147.eu-central-1.compute.amazonaws.com
HOSTNAME=ec2-18-185-18-147.eu-central-1.compute.amazonaws.com
REMOTE_HOST_1=server2@ec2-18-206-71-67.compute-1.amazonaws.com

# PEER_PORT=9001
# HOST=18.185.18.147
# HOST=0.0.0.0
# HOST=172.17.0.3
# HOST=127.0.0.1


# Build container.
# As we did before, but now we are going to build the Docker image that will
# be pushed to the repository.
docker build --pull -t $AWS_ECS_CONTAINER_NAME .

# Tag the new Docker image as latest on the ECS Repository.
docker tag $AWS_ECS_DOCKER_IMAGE "$AWS_ECS_URL"/"$AWS_ECS_DOCKER_IMAGE"

# Login to ECS Repository.
eval $(aws ecr get-login --no-include-email --region $AWS_DEFAULT_REGION --profile $PROFILE_NAME)

# Upload the Docker image to the ECS Repository.
docker push "$AWS_ECS_URL"/"$AWS_ECS_DOCKER_IMAGE"


ecs-cli configure --cluster=$AWS_ECS_CLUSTER_NAME --region=$AWS_DEFAULT_REGION

# ecs-cli configure profile --profile-name $PROFILE_NAME --access-key $AWS_ACCESS_KEY_ID --secret-key $AWS_SECRET_ACCESS_KEY
# Configure ECS cluster and AWS_DEFAULT_REGION so we don't have to send it
# on every command
# ecs-cli configure --cluster=$AWS_ECS_CLUSTER_NAME --region=$AWS_DEFAULT_REGION --aws-profile grisplasp

# Build docker-compose.yml with our configuration.
# Here we are going to replace the docker-compose.yml placeholders with
# our app's configurations
sed \
  -e 's/$AWS_ECS_URL/'$AWS_ECS_URL'/g' \
  -e 's/$AWS_ECS_DOCKER_IMAGE/'$AWS_ECS_DOCKER_IMAGE'/g' \
  -e 's/$AWS_ECS_CONTAINER_NAME/'$AWS_ECS_CONTAINER_NAME'/g' \
  -e 's/$HOST/'$HOST'/g' \
  -e 's/$NODE_NAME/'$NODE_NAME'/g' \
  -e 's/$REMOTE_HOST_1/'$REMOTE_HOST_1'/g' \
  docker-compose.yml.template \
  > docker-compose.yml

# Deregister old task definition.
# Every deploy we want a new task definition to be created with the latest
# configurations. Task definitions are a set of configurations that state
# how the Docker container should run and what resources to use: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html
REVISION=$(aws ecs list-task-definitions --region $AWS_DEFAULT_REGION --profile $PROFILE_NAME | tr -d '"' | tail -1 | rev | cut -d':' -f 1 | rev)
if [ ! -z "$REVISION" ]; then
  aws ecs deregister-task-definition \
    --region $AWS_DEFAULT_REGION \
    --task-definition $AWS_ECS_PROJECT_NAME:$REVISION \
    --profile $PROFILE_NAME \
    >> /dev/null

  # Stop current task that is running ou application.
  # This is what will stop the application.
  ecs-cli compose \
    --file docker-compose.yml \
    --project-name "$AWS_ECS_PROJECT_NAME" \
    service stop \
    --aws-profile $PROFILE_NAME
fi

# Start new task which will create fresh new task definition as well.
# This is what brings the application up with the new changes and configurations.
ecs-cli compose \
  --file docker-compose.yml \
  --project-name "$AWS_ECS_PROJECT_NAME" \
  service up \
  --aws-profile $PROFILE_NAME
