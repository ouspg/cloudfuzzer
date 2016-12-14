#!/bin/bash

#Docker swarm manager address
MASTER_ADDRESS=$(cat $HOME/address_master);

ssh $MASTER_ADDRESS "scripts/collect-results.sh" | tar -zx