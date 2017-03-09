#!/bin/bash

BASTION_ADDRESS=$(cat $HOME/address_bastion)
OWN_ADDRESS=$(hostname -I | awk '{print $1}')

ssh ubuntu@$BASTION_ADDRESS "scripts/helpers.sh get-results $OWN_ADDRESS"

echo "Done syncing, shutting down."
