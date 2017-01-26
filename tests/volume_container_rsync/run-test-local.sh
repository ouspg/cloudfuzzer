#!/bin/bash

#
#This script is for local test of result sync with docker volume container rsync
#

set -o errexit
set -o nounset

CLEANUP=${CLEANUP:=true};
DOCKER0_IP=$(ip addr list docker0 | grep "inet" | cut -d" " -f6 | head -1)

#Start volume-container
VOLUME_CID=$(docker run -d -p 10873:873 -e ALLOW="$DOCKER0_IP" --volume /output -e VOLUME=/output nabeken/docker-volume-container-rsync);
#Create results and samples directories
docker exec $VOLUME_CID bash -c "mkdir /output/results; mkdir /output/samples;";

#Build sample_sync_test docker container
docker build -t sample_sync_test ./;

#Create output folder for results and tmp
[ ! -d ./output/ ] && mkdir ./output/;

#Start sample_sync_test
docker run --cidfile="./output/TEST_CID" -it --volumes-from $VOLUME_CID sample_sync_test;
docker run --cidfile="./output/TEST_CID2" -it --volumes-from $VOLUME_CID sample_sync_test;

#Store test container CIDs
TEST_CID=$(cat ./output/TEST_CID);
TEST_CID2=$(cat ./output/TEST_CID2);

#Remove temp files
rm ./output/TEST_CID;
rm ./output/TEST_CID2;


#rsync results and samples
rsync -r rsync://127.0.0.1:10873/volume ./output;

#Get file lists from local and volume-container
ls output/* | sort > ./output/file-list-local;
docker exec $VOLUME_CID bash -c "cd /; ls output/* | sort" > ./output/file-list-volume-container;

#diff rsync'd files to file list from volume-container, and then against file list that test containers wrote
diff ./output/file-list-local ./output/file-list-volume-container && diff ./output/file-list-local ./output/file-list-test-container;

if [ $? -eq 0 ]; then
	echo "Got:"
	ls output/*
	echo "File lists match."
else
	echo "Something went wrong. See the diff above."
fi


if [ $CLEANUP = true ]; then
	docker rm -f $TEST_CID;
	docker rm -f $TEST_CID2;
	docker rm -f $VOLUME_CID;
	docker rmi sample_sync_test;
	docker rmi nabeken/docker-volume-container-rsync;
	docker volume prune -f;
	rm -rf ./output;
fi