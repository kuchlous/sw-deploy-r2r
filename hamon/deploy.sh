#!/bin/bash
source config

# Set variables in docker-compose.yml.  This is ssort of a hack. Need
# to find out why docker stack deploy doesn't substitute env vars
# properly and fix. If it is not supported, then below method can be
# used.
sed -i 's@${SHARED_DIR}@'"$SHARED_DIR"'@g' docker-compose.yml
sed -i 's@${NGINX}@'"$NGINX"'@g' docker-compose.yml

nodes=(${ELASTIC} ${POSTGRES} ${SW_APP} ${COUCH})
echo "LOG: Nodes are ${nodes[@]}"

# Remove duplicate host ips 
hosts=($(echo "${nodes[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
echo "LOG: Hosts are ${hosts[@]}"

labels=("elasticsearch=true" "postgres=true" "app=true" "couchbase=true")

sudo docker swarm init --advertise-addr ${NGINX}
return_code=$?
if [[ return_code -ne 0 ]];then
    echo "WARNING: This host is already part of swarm. Please leave,"
    echo "to leave run the following command on this host, and run bash deploy.sh again"
    echo "    sudo docker swarm leave -f    "
    exit 1 

echo "LOG: This host set as swarm master"
          
# label current node as nginx
sudo docker node update --label-add "nginx=true" $(hostname)
echo "LOG: Labeled master node  as nginx=true"

# Get the token to join the swarm as worker and construct the joining command
# This will be run in all the other machines 
join_token=$(sudo docker swarm join-token --quiet worker)
join_command="sudo docker swarm join --token $join_token ${NGINX}:2377"

# Add each unique host to swarm
host_count=${#hosts[@]}
echo "LOG: ${host_count} hosts to join"

for((index=0;index<$host_count;++index));do
    return_code=123
    try_count=1
    while [ $return_code -ne 0 ]
    do
        echo "LOG: Going to ssh to ${hosts[$index]} and set it as a worker"
        return_msg=$(ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${hosts[$index]} ${join_command} 2>&1)
        return_code=$?
	    echo "LOG: Return code is $return_code"

        if [ $return_code -ne 0 ]; then
        
               repeat=0
               while [ $repeat = 0 ]
               do
                   if [[ "$return_msg" =~ "This node is already part of a swarm" ]]; then
                       echo "${hosts[$index]} is already part of a swarm. Please leave"
                       echo "the current swarm to use this host.To leave, run the following"
                       echo "command on that host"
                       echo "    sudo docker swarm leave -f    "
                   fi

                   if [[ "$return_msg" =~ "Timeout was reached before node joined" ]]; then
                       echo "${hosts[$index]} Cannot communicate with swarm manager ($NGINX).Please"
                       echo "ensure that $NGINX is configured to allow incomming traffic through "
                       echo "PORT 2377. Also make sure that ports 7946 and 4789 are also configured properly"
                   fi

                   if [[ $return_code = 255 ]];then
                       echo "Cannot ssh to ${hosts[$index]}"
                   fi
                   
                   echo "====================================================="
                   echo "Select continue after the problemm is fixed, to continue the deployment or "
                   echo "select quit to stop the process (Note that selecting 'quit' will rollback the network created by the script)"

                   echo "1) Problem fixed,  contnue "
                   echo "2) Quit"
                   
                   echo -e "Choose 1 or 2 :"
                   read answer
                   
                   case $answer in
                       1) echo "This will resume the deployment from this point"
                          echo "Enter 'c' to confirm OR 'b' to goback"
                          read continue

                          case $continue in
                              c) try_count=1
                                 repeat=1 
                          esac;;

                   
                       2) echo "Going Roll back"
                      
                          # Leave all joined nodes
	                      leave_command="sudo docker swarm leave -f"
	                      for ((i=$index;i>=0;--i));do
		                      ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${hosts[$i]} ${leave_command}
	                      done
	                      sudo docker swarm leave -f
                          exit 1
                          
                     esac
                  done
          
         fi
    done
    
    echo "LOG: ${host[$index]} joined to cluster as worker"
     
done

# Label all nodes 
for((indx=0;indx<4;++indx)); do 
    echo "LOG: Going to label ${nodes[$indx]} as ${labels[$indx]}"
    
    sudo docker node  update --label-add ${labels[$indx]} $(ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${nodes[$indx]} hostname)
    return_code=$?    
	echo "LOG: Label Return code is $return_code"

    if [ $return_code == 0 ]; then
        echo "LOG: ${node[$indx]} node labeled as ${labels[$indx]}"
    else
        echo "LOG: ${node[$indx]} node NOT labeled Successfully"
    fi
done

# Create shared directory in app host
echo "LOG: Going to create shared directory in ${SW_APP}"
ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${SW_APP} "mkdir -p ${SHARED_DIR}log ${SHARED_DIR}system ${SHARED_DIR}tmp"
echo "LOG: Created ${SHARED_DIR} in ${SW_APP} "

# Deploy
echo "LOG: Going to DEPLOY........wait a while"
sudo docker stack deploy -c docker-compose.yml story
echo "LOG: Go to the ${NGINX} with your browser "
