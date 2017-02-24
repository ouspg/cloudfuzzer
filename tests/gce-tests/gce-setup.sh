#!/bin/bash

set -o errexit
set -o nounset

PACKERENV=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $CLOUDFUZZER_DIR/packer/

packer build -only=gcloud -force -var-file=$PACKERENV $CLOUDFUZZER_DIR/packer/packer-bastion.json
packer build -only=gcloud -force -var-file=$PACKERENV $CLOUDFUZZER_DIR/packer/packer-fuzzvm.json

cd $DIR

gcloud compute instances create fuzzvm-1 fuzzvm-2 fuzzvm-3 fuzzvm-4 fuzzvm-5\
	--zone europe-west1-d --image=cloudfuzzer-fuzzvm --no-address

gcloud compute instances create bastion \
    --zone europe-west1-d --image=cloudfuzzer-bastion


echo "Waiting for the machines to spin up..."
sleep 30;

fuzzvms=`scripts/get-gce-ip-addresses.sh fuzzvm`
bastion=`scripts/get-gce-ip-addresses.sh bastion`

cd ..;

eval $(ssh-agent)

ssh-add $CLOUDFUZZER_DIR/vm-keys/bastion-key;

cloudfuzzer bastion setup-swarm $fuzzvms

#Test context in ./context contains docker-image and docker-options files.
cloudfuzzer send-docker-data ubuntu@$bastion $2;

cloudfuzzer bastion run-containers 7;

rm -rf ./test-results/;
mkdir -p ./test-results/;

cloudfuzzer bastion collect-results;
rsync --force -r ubuntu@$bastion:results $CLOUDFUZZER_DIR/test-results;
ls ./test-results/results

cloudfuzzer bastion collect-samples;
rsync --force -r ubuntu@$bastion:samples $CLOUDFUZZER_DIR/test-results;
ls ./test-results/samples
