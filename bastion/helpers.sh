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
    "help" | "")
    print_help $2
    ;;
    *)
        echo "Unknown argument."
    ;;
esac
}

function print_help () {
case $1 in
    "setup-swarm")
        echo "First checks connection to each FuzzVM and that ssh works without passwd."
        echo "Selects first FuzzVM as swarm manager and triggers swarm-create on manager."
        echo "Usage cloudfuzzer setup-swarm <fuzzvm1> <fuzzvm2> ..."
    ;;
    "stop-containers")
        echo "Stop all the running containers"
    ;;
    "run-containers")
        echo "Run containers. Takes number of containers to be run as an argument."
    ;;
    "remove-containers")
        echo "Remove containers"
    ;;
    "distribute-docker-image")
        echo "Loads list of nodes from $HOME/address_nodes and sends image from stdin to all nodes"
        echo "example: docker save <image> | ssh bastion ./distribute-docker-image.sh"
    ;;
    "distribute-local-docker-image")
        echo "Sends docker image from bastion to swarm nodes. Removes image after sending."
        echo "Usage: cloudfuzzer distribute-local-docker-image.sh <image-file>"
    ;;
    "collect-samples")
        echo "Collect samples"
    ;;
    "collect-results")
        echo "Collect-results"
    ;;
    "collect-results-rsync")
        echo "Collect results using rsync"
    ;;
    *)
        echo "Available commands:"
        echo "    collect-results-rsync"
        echo "    collect-results"
        echo "    collect-samples"
        echo "    distribute-docker-image"
        echo "    distribute-local-docker-image"
        echo "    help <command>"
        echo "    remove-containers"
        echo "    run-containers"
        echo "    setup-swarm <fuzzvm1> <fuzzvm2> ..."
        echo "    stop-containers"
    ;;
esac
}

case $- in
    *i*) ;;
      *)
        cloudfuzzer $@

        ;;
esac
