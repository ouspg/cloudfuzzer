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
    "get-results")
        "$DIR/get-results.sh"
    ;;
    "get-stats")
        "$DIR/get-stats.sh"
    ;;
    "ssh-to-master")
        if [ -z "$PS1" ]; then
            echo "This command can only be used with interative shell"
        else
            ssh $(cat $HOME/address_master)
        fi
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
        echo "TODO"
    ;;
    "run-containers")
        echo "Run containers. Takes number of containers to be run as an argument."
    ;;
    "remove-containers")
        echo "Remove containers"
        echo "TODO"
    ;;
    "distribute-docker-image")
        echo "Sends docker image from bastion to swarm nodes. Removes image after sending."
        echo "Usage: cloudfuzzer distribute-local-docker-image.sh <image-file>"
    ;;
    "get-results")
        echo "Get results from fuzzvms"
    ;;
    "get-stats")
        echo "Get stats from master fuzzvm"
    ;;
    "ssh-to-master")
        echo "ssh to fuzzvm swarm master"
    ;;
    *)
        echo "Available commands:"
        echo "    get-results"
        echo "    get-stats"
        echo "    distribute-docker-image"
        echo "    remove-containers"
        echo "    run-containers <count>"
        echo "    setup-swarm <fuzzvm1> <fuzzvm2> ..."
        echo "    stop-containers"
        if [ ! -z "$PS1" ]; then
            echo "    ssh-to-master"
        fi
    ;;
esac
}

case $- in
    *i*) ;;
      *)
        cloudfuzzer $@

        ;;
esac
