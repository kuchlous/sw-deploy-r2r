#!/bin/bash
source config

# Set variables in docker-compose.yml.  This is ssort of a hack. Need
# to find out why docker stack deploy doesn't substitute env vars
# properly and fix. If it is not supported, then below method can be
# used.
sed -i 's@${SHARED_DIR}@'"$SHARED_DIR"'@g' docker-compose.yml
sed -i 's@${NGINX}@'"$NGINX"'@g' docker-compose.yml

nodes=(${ELASTIC} ${POSTGRES} ${SW_APP} ${COUCH})
labels=("elasticsearch=true" "postgres=true" "app=true" "couchbase=true")

sudo docker swarm init
echo "LOG: ${NGINX} This system initiated swarm cluster and role as master"

# label current node as nginx
sudo docker node update --label-add "nginx=true" $(hostname)
echo "LOG: Labeled master node  as nginx=true"

# Get the token to join the swarm as worker and construct the joining command
# This will be run in all the other machines 
join_command="sudo docker swarm join --token $(sudo docker swarm join-token --quiet worker) ${NGINX}:2377"
echo "LOG: join commad is ${join_command}"

# Add all other machines as swarm workers and assign appropriate labels 
for ((index=0;index<4;++index)); do
    return_code=123
    try_count=1
    while [ $return_code -ne 0 ]
    do
        echo "LOG: Going to ssh to ${nodes[$index]} and set it as a worker"
        ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${nodes[$index]} ${join_command}
        return_code=$?
	echo "LOG: Return code is $return_code"
        if [ $return_code -ne 0 ]; then
            (( ++try_count ))
            echo "WARNING: Some thing going wrong with ${nodes[$index]} Pls confirm the host is runnig and ports TCP 2377, TCP and UDP 7946 and UDP 4789 are OPEN"
        fi

        if [ $try_count -gt 3]; then
            echo "WARNING: Tried 3 times to connect with ${nodes[$index]}; SO going to STOP all process"
            echo "make sure all hosts are configured correctly and try again"
            exit 1
        fi
    done
    
    echo "LOG: ${node[$index]} joined to cluster as worker"
     
    echo "LOG: Going to label ${node[$index]} as ${labels[$index]}"
    sudo docker node  update --label-add ${labels[$index]} $(ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${nodes[$index]} hostname)
    echo "LOG: ${node[$index]} node labeled as ${labels[$index]}"
done

# Create shared directory in app host
echo "LOG: Going to create shared directory in ${SW_APP}"
ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${SW_APP} "mkdir -p ${SHARED_DIR}log ${SHARED_DIR}system ${SHARED_DIR}tmp"
echo "LOG: Created ${SHARED_DIR} in ${SW_APP} "

# Deploy
echo "LOG: Going to DEPLOY........wait a while"
sudo docker stack deploy -c docker-compose.yml story
echo "LOG: Go to the ${NGINX} with your browser "
