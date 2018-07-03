#! /usr/bin/env /bin/bash

echo "Building the test docker image"
sudo docker build -t $IMAGE $FILE_PATH

#Removing old containers if any
if [ "$(sudo docker container ls -a | grep $CONTAINER)" ]; then
   sudo docker stop $CONTAINER
   sudo docker rm $CONTAINER
fi

echo "Running the container"
sudo docker run --env-file $FILE_PATH/env.list -v $VOLUME:/workdir --name $CONTAINER $IMAGE
exit_status=$(sudo docker inspect $CONTAINER --format='{{.State.ExitCode}}')
if [ "$exit_status" -eq 0 ]; then
  exit 0
else
  exit 1
fi
