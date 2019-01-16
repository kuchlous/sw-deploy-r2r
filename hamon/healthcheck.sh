#!/bin/bash
LOG_FILE=deploy.log

# Remove existing story stack
echo "Going to remove existing stack" | tee -a $LOG_FILE   
sudo docker stack rm story

# Wait for a while for remove stack
echo "Removing....wait...a..while"
sleep(60)


# Redeploy the stack
echo "Going to Redeploy" | tee -a $LOG_FILE   
sudo docker stack deploy -c docker-compose.yml story
