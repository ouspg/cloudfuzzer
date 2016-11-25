#!/bin/bash

#Check all nodes connected to discovery

#Todo: Need improvement

MASTER=`cat $HOME/address_master`

for node in $(cat $HOME/address_nodes)
do
    echo "Checking node: $node"
    ssh $MASTER "docker -H :4000 info |grep -A 2 $node|grep Status"
done
