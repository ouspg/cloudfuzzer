#!/bin/bash

set -o errexit
set -o nounset

COUNT=$1

MASTER_ADDRESS=$(cat $HOME/address_master)

scp $HOME/docker-arguments $MASTER_ADDRESS:
ssh $MASTER_ADDRESS "./scripts/run-containers.sh $COUNT"