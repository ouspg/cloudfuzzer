#!/bin/bash

#usage: upload-dockerimage.sh <docker-image> <bastion> <fuzzvm1> <fuzzvm2> ...

#example: ./upload-dockerimage.sh <docker-image> <bastion> `./get-gcloud-fuzzvm-ips.sh`

echo "Image name: $1"
echo "Bastion: $2"

for i in ${@:3}
do
    echo "FuzzVM: $i"
    docker save $1  | gzip  | pv | ssh ubuntu@$2 "cat | pv | ssh $i \"docker load\" " &
done
