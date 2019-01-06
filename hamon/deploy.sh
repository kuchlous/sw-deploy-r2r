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
    
echo "LOG: ${NGINX} This system initiated swarm cluster and role as master"

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
        ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${USER}@${hosts[$index]} ${join_command}
        return_code=$?
	    echo "LOG: Return code is $return_code"

        if [ $return_code -ne 0 ]; then
            (( ++try_count ))
            echo "WARNING: Some thing going wrong with ${hosts[$index]} Pls confirm the host is runnig and ports TCP 2377, TCP and UDP 7946 and UDP 4789 are OPEN"

            # if it brake 3 times going to debug 
            if [ $try_count -gt 3 ]; then
               repeat=0
               echo "WARNING: Tried 3 times to connect with ${hosts[$index]}"
               while [ $repeat = 0 ]
               do 
                   echo "====================================================="
                   echo "Select the Recovery options:"
                   echo "Enter 1 for Check port and ssh issue of ${hosts[$index]} manually and try again "
                   echo "Enter 2 for Run join command manualy in ${hosts[$index]}" 
                   echo "Enter 3 for Change host"
                   #echo -e "\n"
                   echo -e "Select your option:"
                   read answer
                   
                   case $answer in
                       1) echo "Pls Check the port issue and ssh issue with ${hosts[$index]}"
                          echo "Enter c after fix OR ch for change option"
                          read continue

                          case $continue in
                              c) try_count=1
                                 repeat=1 
                          esac;;

                       2) echo "----------------------------------------------------"
                          echo -e "\n"
                          echo $join_command
                          echo -e "\n"
                          echo "Run this command on ${hosts[$index]}"
                          echo "Make sure its return Node join as worker message"

                          echo "Enter c if joined Successfully OR ch for change option"
                          read continue

                          case $continue in
                              c) repeat=1
                                 try_count=1
                                 return_code=0
                          esac;;

                       3) echo "Going Roll back"
                      
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
#sudo docker stack deploy -c docker-compose.yml story
echo "LOG: Go to the ${NGINX} with your browser "
