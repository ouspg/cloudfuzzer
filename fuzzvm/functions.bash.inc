#!/bin/bash

NODE_ADDRESSES=$(cat $HOME/address_nodes);
BASTION_ADDRESS=$(cat $HOME/address_bastion);
MASTER_ADDRESS=$(cat $HOME/address_master);

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

cloudfuzzer () {
case $1 in
    "check-internet")
    "$DIR/check-internet.sh"
    ;;
    "collect-results-from-remote")
    "$DIR/collect-results-from-remote.sh"
    ;;
    "collect-results")
    "$DIR/collect-results.sh"
    ;;
    "collect-samples")
    "$DIR/collect-samples.sh"
    ;;
    "get-samples-from-container")
    "$DIR/get-samples-from-container.sh" $2
    ;;
    "remove-containers")
    "$DIR/remove-containers.sh"
    ;;
    "run-containers")
    "$DIR/run-containers.sh" $2
    ;;
    "setup-node")
    "$DIR/setup-node.sh" $2 $3
    ;;
    "stop-containers")
    "$DIR/stop-containers.sh"
    ;;
    "swarm-create")
    "$DIR/swarm-create.sh" ${@:2}
    ;;
    "help")
    print_help $2
    ;;
    *)
    echo "Unknown argument."
    ;;
esac
}

function print_help () {
    case $1 in
    "check-internet")
    echo "Run to check if the node is connected to Internet. There should be no Internet connection in fuzzing nodes (fuzzvm)."
    ;;
    "collect-results-from-remote")
    echo "Collects results to master. Used for debugging."
    ;;
    "collect-results")
    echo "Collects results to bastion."
    ;;
    "collect-samples")
    echo "Collects results to bastion."
    ;;
    "get-samples-from-container")
    echo "Collect diff of samples from container."
    ;;
    "remove-containers")
    echo "Remove the containers."
    ;;
    "run-containers")
    echo "Run the containers."
    ;;
    "setup-node")
    echo "help setup-node"
    ;;
    "stop-containers")
    echo "Stop running containers."
    ;;
    "swarm-create")
    echo "Script for swarm master setup"
    ;;
    *)
    echo "Available commands:"
    echo "check-internet"
    echo "collect-results-from-remote"
    echo "collect-results"
    echo "collect-samples"
    echo "get-samples-from-container"
    echo "remove-containers"
    echo "run-containers"
    echo "setup-node"
    echo "stop-containers"
    echo "swarm-create"
    echo "help <command>"
    ;;
esac
}
