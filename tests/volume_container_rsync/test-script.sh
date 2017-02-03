#!/bin/bash


echo "Starting test...";

#We just write dummy-files to the samples and results folders.
mkdir -p /output/samples;
mkdir -p /output/results;

count=0;
SCID=$(cat /etc/hostname);
while true; do
    let count++;
    echo "Adding sample: sample-$SCID-$count"
    echo "$count" > /output/samples/sample-$SCID-$count;

    if ! ((count % 2)); then
        echo "Adding result: crash-$SCID-$count"
        echo "$count" > /output/results/crash-$SCID-$count;
    fi

    sleep 0.2;
    if [ $count -gt 10 ]; then
        break;
    fi
done

#Store file list as seen inside the container
touch /output/file-list-test-container;
cd /;
ls output/* | sort > /output/file-list-test-container;