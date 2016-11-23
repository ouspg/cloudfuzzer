
#!/bin/bash

#
#Loads list of nodes from $HOME/address_nodes and sends image from stdin to all nodes
#

#example: docker save <image> | ssh bastion "./distribute-docker-image.sh"


echo "Saving image to bastion."

IMAGE="default-image.tar"

cat > $IMAGE

for node in $(cat $HOME/address_nodes) 
do
    echo "FuzzVM: $node"
    cat $IMAGE | bzip2 | ssh $node "bunzip2 | docker load;";
done

echo "Removing image from bastion."
rm $IMAGE;