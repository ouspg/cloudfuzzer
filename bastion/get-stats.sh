#!/bin/bash

set -o errexit
set -o nounset

MASTER_ADDRESS=$(cat $HOME/address_master)

ssh $MASTER_ADDRESS "./scripts/get-stats.sh"

if [ -d $HOME/stats ]; then
	rm -rf $HOME/stats
fi 

mkdir $HOME/stats

scp $MASTER_ADDRESS:stats/* $HOME/stats