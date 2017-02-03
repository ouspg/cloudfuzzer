#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

check-internet () {
"$DIR/check-internet.sh"
}

collect-results-from-remote () {
"$DIR/collect-results-from-remote.sh"
}

collect-results () {
"$DIR/collect-results.sh"
}

collect-samples () {
"$DIR/collect-samples.sh"
}

get-samples-from-container () {
"$DIR/get-samples-from-container.sh" $1
}

remove-containers () {
"$DIR/remove-containers.sh"
}

run-containers () {
"$DIR/run-containers.sh" $1
}

setup-node () {
"$DIR/setup-node.sh" $1 $2
}

stop-containers () {
"$DIR/stop-containers.sh"
}

swarm-create () {
"$DIR/swarm-create.sh" $@
}
