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
    echo "Command not found."
    ;;
esac
}

function print_help () {
    case $1 in
    "check-internet")
    echo "help check-internet"
    ;;
    "collect-results-from-remote")
    echo "help collect-results-from-remote"
    ;;
    "collect-results")
    echo "help collect-results"
    ;;
    "collect-samples")
    echo "help collect-samples"
    ;;
    "get-samples-from-container")
    echo "help get-samples-from-container"
    ;;
    "remove-containers")
    echo "help remove-containers"
    ;;
    "run-containers")
    echo "help run-containers"
    ;;
    "setup-node")
    echo "help setup-node"
    ;;
    "stop-containers")
    echo "help stop-containers"
    ;;
    "swarm-create")
    echo "help swarm-create"
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
    echo "help (command)"
    ;;
esac
}
