#!/bin/bash

set -o errexit
set -o nounset

if [ $# -eq 0 ]
    then
        NODES=$(cat $HOME/address_nodes)
    else
        NODES=$@
fi

# Rsync nodes
for node in $NODES; do
	rsync -auP --no-links --min-size=1 rsync://$node:10873/volume/ results/
done
