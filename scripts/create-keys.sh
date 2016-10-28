#!/bin/bash

cd $(dirname "$(readlink -f "$0")");


#Create vm-keys folder, if it doesn't exist.
if [ ! -d ../vm-keys ]; then
	mkdir -p ../vm-keys;

cd ../vm-keys;

#Create keys for bastion
if [ ! -f ./bastion-key ]; then
	echo "No keys for bastion..."
	echo "Generating: $(pwd)/bastion-key and $(pwd)/bastion-key.pub"
	ssh-keygen -N '' -t rsa -b 4096 -C "bastion" -f bastion-key
else
	echo "Keys for bastion already exist..."
fi

#Create keys for fuzzvm
if [ ! -f ./fuzzvm-key ]; then
	echo "No keys for fuzzvm..."
	echo "Generating: $(pwd)/fuzzvm-key and $(pwd)/fuzzvm-key.pub"	
	ssh-keygen -N '' -t rsa -b 4096 -C "fuzzvm" -f fuzzvm-key
else
	echo "Keys for fuzzvm already exist..."
fi

