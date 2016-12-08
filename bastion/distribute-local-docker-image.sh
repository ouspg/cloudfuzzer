
#!/bin/bash

#
#Sends docker image from bastion to swarm nodes. Removes image after sending.
#
# 

#Usage: ./distribute-local-docker-image.sh <image-file>

IMAGE="$1"


for node in $(cat $HOME/address_nodes) 
do
    echo "FuzzVM: $node"
    cat $IMAGE | bzip2 | ssh $node "bunzip2 | docker load;";
done

echo "Removing image from bastion."
rm $IMAGE;