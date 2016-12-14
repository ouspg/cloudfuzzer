#!/bin/bash

packer build -only=gcloud -force -var-file=$HOME/variables.json ../packer/packer-bastion.json
packer build -only=gcloud -force -var-file=$HOME/variables.json ../packer/packer-fuzzvm.json

gcloud compute instances create bastion \
    --zone europe-west1-d --image=cloudfuzzer-bastion

gcloud compute instances create fuzzvm-1 \
    fuzzvm-2 fuzzvm-3 fuzzvm-4 fuzzvm-5 --zone europe-west1-d --image=cloudfuzzer-fuzzvm --no-address

fuzzvms=`gcloud compute instances list | grep fuzzvm | awk '{print $5}' | xargs`
bastion=`gcloud compute instances list | grep bastion| awk '{print $5}'`

ssh -i "../vm-keys/bastion-key" ubuntu@$bastion "scripts/setup-swarm.sh $fuzzvms"

#./send-docker-data.sh

