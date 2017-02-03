#!/bin/bash

set -o errexit
set -o nounset

MASTER_ADDRESS=$(cat $HOME/address_master)

ssh $MASTER_ADDRESS "./scripts/remove-containers.sh"