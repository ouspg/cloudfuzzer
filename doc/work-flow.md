# Cloudfuzzer work flow

## Pre work
* packer build images on the cloud

## Work flow
* docker build <image>
* create-N-fuzzvm <user-defined>
* create-1-bastion <user-defined>
* ssh bastion "scripts/setup-swarm <nodes>"
* docker save <img> | ssh bastion "scripts/distribute-docker-image.sh"
* ssh bastion "scripts/health.sh"
* ssh bastion "scripts/fuzz.sh"
* sleep 10000
* get-results.sh <user-defined>
* ssh bastion "scripts/stop.sh"
* exit

## Result sync
* rsync
* no-overwrite
* no delete sync
###fuzzvm
* sync on terminate
* sync time interval
* clean local
* sync on bastion command
