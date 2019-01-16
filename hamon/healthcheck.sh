#!/bin/bash
LOG_FILE=deploy.log

# Check whether the nginx running correctly

# Get the container id of nginx
while [ -z $CONTAINER_ID ]; do
    CONTAINER_ID=$(sudo docker ps -qf name=story_sw-nginx)
    sleep 10
done

#Try to restart nginx service
RETURN_MSG=$(sudo docker exec -t  $CONTAINER_ID service nginx restart)

#check wether have DNS issue if have redeploy the stack
if [[ "$RETURN_MSG" =~ "host not found in upstream" ]]; then
        
    # Remove existing story stack
    echo "Going to remove existing stack" | tee -a $LOG_FILE   
    sudo docker stack rm story

    # Wait for a while for remove stack
    echo "Removing....wait...a..while"
    sleep 60


    # Redeploy the stack
    echo "Going to Redeploy" | tee -a $LOG_FILE   
    sudo docker stack deploy -c docker-compose.yml story
    sleep 60
fi
