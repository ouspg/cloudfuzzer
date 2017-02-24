#!/bin/bash

set -o errexit
set -o nounset
##
##Swarm setup script
##

#usage: setup-swarm.sh <fuzzvm1> <fuzzvm2> ...

#example: ssh bastion "./setup-swarm.sh $(./get-gcloud-fuzzvm-ips.sh)"

#First checks connection to each FuzzVM and that ssh works without passwd.
#Selects first FuzzVM as swarm manager and triggers swarm-create on manager.

ADDRESSES="$@"

OWN_ADDRESS=$(hostname -I | awk '{print $1}')

echo "Bastion: $OWN_ADDRESS"
echo "FuzzVMs: $ADDRESSES"

echo "Checking connection to all FuzzVMs."

for fuzzvm in $ADDRESSES; do
	echo "Checking $fuzzvm"
	ssh $fuzzvm -o StrictHostKeyChecking=no -o ConnectTimeout=10 'echo -n $HOSTNAME\($(hostname -I | awk '\''{print $1}'\'')\);' && echo " - Online"
	if [ $? -ne 0 ]; then
		echo "Couldn't reach host: $fuzzvm"
		echo "Before rerunning this script:"
		echo "Check that you provided valid address for FuzzVM instance, in a form that can be used in ssh <address>."
		echo "Also check that you are using correct username, that has the ssh-keys set."
		exit;
	fi
done

SWARM_MASTER=$1;
shift;
SWARM_NODES=$@;

echo $SWARM_MASTER > $HOME/address_master;
echo $SWARM_MASTER $SWARM_NODES > $HOME/address_nodes;
echo $OWN_ADDRESS > $HOME/address_bastion

scp $HOME/address_* $SWARM_MASTER:

echo "Selected $SWARM_MASTER as swarm master"
echo "Starting swarm-create.sh on swarm master"
ssh $SWARM_MASTER "scripts/swarm-create.sh";
