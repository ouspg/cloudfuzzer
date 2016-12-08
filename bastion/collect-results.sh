#!/bin/bash

#Docker swarm manager address
MASTER_ADDRESS=$(cat $HOME/address_master);

ssh $MASTER_ADDRESS "./collect-results.sh" | tar x