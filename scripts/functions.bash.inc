#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source $DIR/../cloudfuzzer.conf
source $DIR/../user.conf

cloudfuzzer () {
case $1 in
    "create-keys")
    if [ $2 = "help" ]
    then
        echo "Create keys in vm-keys folder to be used in bastion and fuzzvm. If keys already exist no kew keys are created."
    else
    "$DIR/create-keys.sh"
    fi
    ;;
    "gce-setup")
    "create-keys")
    if [ $2 = "help" ]
    then
        echo "Create keys in vm-keys folder to be used in bastion and fuzzvm. If keys already exist no kew keys are created."
    else
    "$DIR/gce-setup.sh" ${@:2}
    fi
    ;;
    "send-docker-data")
    if [ $2 = "help" ]
    then
        echo "Send docker data to cloud. Bastion address must be given as first argument. Second argument is context directory."
        echo "context directory must contain two files: docker-image and docker-image."
        echo "docker save <image> | gzip > docker-image"
        echo "docker-options file must contain docker options"
    else
    "$DIR/send-docker-data.sh" ${@:2}
    fi
    ;;
    "bastion")
    ssh $SSH_OPTS $BASTION_USER@$BASTION "/home/ubuntu/scripts/helpers.sh ${@:2}"
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
    "bastion")
    ssh ubuntu@$BASTION "scripts/helpers.sh help"
    ;;
    *)
    echo "Available commands:"
    echo "create-keys"
    echo "gce-setup <packerenv>"
    echo "send-docker-data <bastion-address> <directory>"
    echo "bastion <command>"
    echo "help <command>"
    ;;
esac
}
