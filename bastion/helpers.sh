#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

cloudfuzzer () {
case $1 in
    "setup-swarm")
        "$DIR/setup-swarm.sh" ${@:2}
    ;;
    "stop-containers")
        echo "TODO"
    ;;
    "run-containers")
        "$DIR/run-containers.sh" $2
    ;;
    "remove-containers")
        echo "TODO"
    ;;
    "distribute-docker-image")
        "$DIR/distribute-docker-image.sh" $2
    ;;
    "collect-results")
        "$DIR/collect-results.sh"
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
        echo "Sends docker image from bastion to swarm nodes. Removes image after sending."
        echo "Usage: cloudfuzzer distribute-local-docker-image.sh <image-file>"
    ;;
    "collect-results")
        echo "Collect-results"
    ;;
    *)
        echo "Available commands:"
        echo "    collect-results"
        echo "    collect-samples"
        echo "    distribute-docker-image"
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
