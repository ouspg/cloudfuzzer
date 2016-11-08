#!/bin/bash

##
##Swarm setup script
##

ADDRESSES="$@"

echo "FuzzVMs: ADDRESSES"

echo "Checking connection to all FuzzVMs."

for fuzzvm in $ADDRESSES; do
	echo "Checking $fuzzvm"
	ssh $fuzzvm -o ConnectTimeout=10 'echo -n $HOSTNAME\($(hostname -I | awk '\''{print $1}'\'')\);' && echo " - Online"
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

echo "Selected $SWARM_MASTER as swarm master"
echo "Starting swarm-create.sh on swarm master"
ssh $SWARM_MASTER "scripts/swarm-create.sh $SWARM_NODES";

