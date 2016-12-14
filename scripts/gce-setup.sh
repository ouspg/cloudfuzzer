#!/bin/bash

set -o errexit
set -o nounset

PACKERENV=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR;

packer build -only=gcloud -force -var-file=$PACKERENV $DIR/../packer/packer-bastion.json
packer build -only=gcloud -force -var-file=$PACKERENV $DIR/../packer/packer-fuzzvm.json

gcloud compute instances create bastion \
    --zone europe-west1-d --image=cloudfuzzer-bastion

gcloud compute instances create fuzzvm-1 \
    fuzzvm-2 fuzzvm-3 fuzzvm-4 fuzzvm-5 --zone europe-west1-d --image=cloudfuzzer-fuzzvm --no-address

echo "Waiting for the machines to spin up..."
sleep 30;

fuzzvms=`gcloud compute instances list | grep fuzzvm | awk '{print $4}' | xargs`
bastion=`gcloud compute instances list | grep bastion| awk '{print $5}'`

cd ..;

eval $(ssh-agent)

ssh-add ./vm-keys/bastion-key;

ssh -o StrictHostKeyChecking=no ubuntu@$bastion	"scripts/setup-swarm.sh $fuzzvms"

#Test context in ./context contains docker-image and docker-options files.
bash scripts/send-docker-data.sh ubuntu@$bastion ./context/

ssh -o StrictHostKeyChecking=no ubuntu@$bastion "scripts/run-containers.sh 5"

ssh -o StrictHostKeyChecking=no ubuntu@$bastion "scripts/collect-results.sh"

mkdir ./context/test/

rsync -r ubuntu@$bastion:results ./context/test

ssh -o StrictHostKeyChecking=no ubuntu@$bastion "scripts/collect-samples.sh"

rsync -r ubuntu@$bastion:samples ./context/test
