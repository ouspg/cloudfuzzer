#!/bin/bash

BASTION=130.211.51.217

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

cloudfuzzer () {
case $1 in
    "create-keys")
    "$DIR/create-keys.sh"
    ;;
    "gce-setup")
    "$DIR/gce-setup.sh" ${@:2}
    ;;
    "send-docker-data")
    "$DIR/send-docker-data.sh" ${@:2}
    ;;
    "bastion")
    ssh ubuntu@$BASTION "${@:2}" 
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
    "create-keys")
    echo "Create keys in vm-keys folder to be used in bastion and fuzzvm. If keys already exist no kew keys are created."
    ;;
    "gce-setup")
    echo "Setup script for Google Cloud. Packer environment variables files is required as an argument."
    ;;
    "send-docker-data")
    echo "Send docker data to cloud. Bastion address must be given as first argument. Second argument is context directory."
    echo "context directory must contain two files: docker-image and docker-image."
    echo "docker save <image> | gzip > docker-image"
    echo "docker-options file must contain docker options"
    ;;
    *)
    echo "Available commands:"
    echo "create-keys"
    echo "gce-setup <packerenv>"
    echo "send-docker-data <bastion-address> <directory>"
    echo "help <command>"
    ;;
esac
}
