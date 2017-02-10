#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

cloudfuzzer () {
case $1 in
    "setup-swarm")
    "$DIR/setup-swarm.sh" ${@:2}
    ;;
    "stop-containers")
    "$DIR/stop-containers.sh"
    ;;
    "run-containers")
    "$DIR/run-containers.sh" $2
    ;;
    "remove-containers")
    "$DIR/remove-containers.sh"
    ;;
    "distribute-docker-image")
    "$DIR/distribute-docker-image.sh"
    ;;
    "distribute-local-docker-image")
    "$DIR/distribute-local-docker-image.sh" $2
    ;;
    "collect-samples")
    "$DIR/collect-samples.sh"
    ;;
    "collect-results")
    "$DIR/collect-results.sh"
    ;;
    "collect-results-rsync")
    "$DIR/collect-results-rsync.sh"
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
    "setup-swarm")
    echo "help setup-swarm"
    ;;
    "stop-containers")
    echo "help stop-containers"
    ;;
    "run-containers")
    echo "help run-containers"
    ;;
    "remove-containers")
    echo "help remove-containers"
    ;;
    "distribute-docker-image")
    echo "help distribute-docker-image"
    ;;
    "distribute-local-docker-image")
    echo "help distribute-local-docker-image"
    ;;
    "collect-samples")
    echo "help collect-samples"
    ;;
    "collect-results")
    echo "help collect-results"
    ;;
    "collect-results-rsync")
    echo "help collect-results-rsync"
    ;;
    *)
    echo "Available commands:"
    echo "setup-swarm (addresses ...)"
    echo "stop-containers"
    echo "run-containers"
    echo "remove-containers"
    echo "distribute-docker-image"
    echo "distribute-local-docker-image"
    echo "collect-samples"
    echo "collect-results"
    echo "collect-results-rsync"
    echo "help (command)"
    ;;
esac
}
