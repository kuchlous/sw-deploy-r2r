#!/bin/bash
source config
nodes=(${ELASTIC} ${POSTGRES} ${SW_APP} ${COUCH})
labels=("elastic=true" "postgres=true" "sw_app=true" "couch=true")

sudo docker swarm init

# label current node as nginx
sudo docker node update --label-add "nginx=true" $(hostname)

# Get the token to join the swarm as worker and construct the joining command
# This will be run in all the other machines 
join_command="sudo docker swarm join --token $(sudo docker swarm join-token --quiet worker) ${NGINX}:2377"

# Add all other machines as swarm workers and assign appropriate labels 
for ((index=0;index<4;++index)); do
     ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${nodes[$index]} ${join_command} 
     sudo docker node  update --label-add ${labels[$index]} $(ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${nodes[$index]} hostname)
done

# Create shared directory in app host
ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${SW_APP} "mkdir -p ${SHARED_DIR}"


