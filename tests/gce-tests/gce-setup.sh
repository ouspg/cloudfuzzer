#!/bin/bash

if (( $# == 2 )); then
	source ../../scripts/functions.bash.inc

	set -o errexit
	set -o nounset

	PACKERENV=$1

	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

	cd $CLOUDFUZZER_DIR/packer/

	packer build -only=gcloud -force -var-file=$PACKERENV $CLOUDFUZZER_DIR/packer/packer-bastion.json
	packer build -only=gcloud -force -var-file=$PACKERENV $CLOUDFUZZER_DIR/packer/packer-fuzzvm.json

	cd $DIR

	gcloud compute instances create fuzzvm-1 fuzzvm-2 fuzzvm-3 fuzzvm-4 fuzzvm-5 \
		--zone europe-west1-d --image=cloudfuzzer-fuzzvm --no-address \
		--metadata-from-file shutdown-script=$CLOUDFUZZER_DIR/fuzzvm/sync-results.sh

	gcloud compute instances create bastion \
	    --zone europe-west1-d --image=cloudfuzzer-bastion


	echo "Waiting for the machines to spin up..."
	sleep 30;

	FUZZVM_ADDRESSES=`scripts/get-gce-ip-address.sh fuzzvm`
	export BASTION_ADDRESS=`scripts/get-gce-ip-address.sh bastion`

	cloudfuzzer bastion setup-swarm $FUZZVM_ADDRESSES

	#Test context in ./context contains docker-image and docker-options files.
	cloudfuzzer send-docker-data $2;

	cloudfuzzer bastion run-containers 7;

	rm -rf ./test-results/;
	mkdir -p ./test-results/;

	sleep 10;

	cloudfuzzer get-stats ./test-results;

	cloudfuzzer get-results ./test-results;
else
	echo "Illegal number of arguments given. Two required: packer variables file and context directory."
	echo "Usage ./gce-setup <variables> <context>"
fi
