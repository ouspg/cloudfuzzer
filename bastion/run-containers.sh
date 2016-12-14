#!/bin/bash

COUNT=$1

MASTER_ADDRESS=$(cat $HOME/address_master)

scp $HOME/docker-options $MASTER_ADDRESS:
ssh $MASTER_ADDRESS "./scripts/run-containers.sh $COUNT"