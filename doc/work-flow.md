# Cloudfuzzer work flow

## Pre work
* packer build images on the cloud

## Work flow
* docker build &lt;image&gt;
* create-N-fuzzvm &lt;user-defined&gt;
* create-1-bastion &lt;user-defined&gt;
* ssh bastion "scripts/setup-swarm &lt;nodes&gt;"
* docker save &lt;img&gt; | ssh bastion "scripts/distribute-docker-image.sh"
* ssh bastion "scripts/health.sh"
* ssh bastion "scripts/fuzz.sh"
* sleep 10000
* get-results.sh &lt;user-defined&gt;
* ssh bastion "scripts/stop.sh"
* exit

## Result sync
* rsync
* no-overwrite
* no delete sync
## fuzzvm
* sync on terminate
* sync time interval
* clean local
* sync on bastion command
