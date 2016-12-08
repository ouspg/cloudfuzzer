#!/bin/bash

#Check all nodes connected to discovery

#Todo: Need improvement

MASTER=`cat $HOME/address_master`

for node in $(cat $HOME/address_nodes)
do
    echo "Checking node: $node"
    result=$(ssh $MASTER "docker -H :4000 info 2>/dev/null |grep -A 2 $node|grep Status")
    echo $result
    #if grep --quiet "Healthy" $result; then
    #    then echo "Is healthy"
    #    else echo "Is not healthy"
    #fi
done
