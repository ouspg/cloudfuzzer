
#!/bin/bash

#usage: distribute-docker-image.sh <docker-image> <bastion> <fuzzvm1> <fuzzvm2> ...

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