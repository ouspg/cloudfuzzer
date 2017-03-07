#!/bin/bash

set -o errexit
set -o nounset

#
#Collect various logs from our docker swarm
#

if [ -d $HOME/stats ]; then
    rm -rf $HOME/stats
fi

mkdir $HOME/stats

COMMANDS=(
    "docker service list"
    "docker service inspect fuzz-service --pretty"
    "docker service ps fuzz-service"
)

for COMMAND in "${COMMANDS[@]}"; do 
    echo $COMMAND | tee -a $HOME/stats/cloudfuzzer-stats.log 
    timeout 10s $COMMAND | tee -a $HOME/stats/cloudfuzzer-stats.log 
    echo ""
done

timeout 10s docker service logs fuzz-service | gzip > $HOME/stats/fuzz-service-log.gz