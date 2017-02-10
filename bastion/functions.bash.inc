#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

setup-swarm () {
"$DIR/setup-swarm.sh" $@
}

stop-containers () {
"$DIR/stop-containers.sh"
}

run-containers () {
"$DIR/run-containers.sh" $1
}

remove-containers () {
"$DIR/remove-containers.sh"
}

distribute-docker-image () {
"$DIR/distribute-docker-image.sh"
}

distribute-local-docker-image () {
"$DIR/distribute-local-docker-image.sh" $1
}

collect-samples () {
"$DIR/collect-samples.sh"
}

collect-results () {
"$DIR/collect-results.sh"
}

collect-results-rsync () {
"$DIR/collect-results-rsync.sh"
}
