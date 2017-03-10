#!/bin/bash

set -o errexit
set -o nounset

REMOTE_DIRECTORY=$1
LOCAL_DIRECTORY=$2

echo "Fetching $REMOTE_DIRECTORY to $LOCAL_DIRECTORY"

rsync -auP -z --no-links --min-size=1 -r $BASTION_USER@$BASTION_ADDRESS:$REMOTE_DIRECTORY/* $LOCAL_DIRECTORY;