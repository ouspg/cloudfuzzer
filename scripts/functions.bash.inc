#!/bin/bash

export CLOUDFUZZER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

CLOUDFUZZER_CONF="$CLOUDFUZZER_DIR/cloudfuzzer.conf"
USER_CONF="$CLOUDFUZZER_DIR/user.conf"

if [ -f $CLOUDFUZZER_CONF ]
then
	source $CLOUDFUZZER_CONF
else
	echo "ERROR: $CLOUDFUZZER_CONF not found. Aborted."
	return 1
fi

if [ -f $USER_CONF ]
then
	source $USER_CONF
fi

if [ -z $BASTION_ADDRESS ]; then
    echo "BASTION_ADDRESS not set."
    echo "You have to set it, fefore running using send-docker-data, or any cloudfuzzer bastion <command>"
    echo "You can set it to $CLOUDFUZZER_CONF or $USER_CONF, and rerun source command."
    echo "Or later use: export BASTION_ADDRESS=<bastion-address>"
else
    export BASTION_ADDRESS=$BASTION_ADDRESS
fi

if [ -z $BASTION_USER ]; then
    echo "BASTION_USER not set."
    echo "You have to set it, fefore running using send-docker-data, or any cloudfuzzer bastion <command>"
    echo "You can set it to $CLOUDFUZZER_CONF or $USER_CONF, and rerun source command."
    echo "Or later use: export BASTION_USER=<username>, to set it"
else
    export BASTION_USER=$BASTION_USER
fi

is_bastion_env_set (){
    if [ -z $BASTION_ADDRESS ]; then
        echo "BASTION_ADDRESS not set."
        return 1
    elif [ -z $BASTION_USER ]; then
        echo "BASTION_USER not set."
        return 1
    fi
    return 0
}

cloudfuzzer () {
    case $1 in
        "create-keys")
            if [ "$2" == "help" ]; then
                echo "Create keys in vm-keys folder to be used in bastion and fuzzvm. If keys already exist no kew keys are created."
            else
                "$CLOUDFUZZER_DIR/scripts/create-keys.sh"
            fi
        ;;
        "send-docker-data")
            if [ "$2" == "help" ]; then
                echo "Send docker data directory to bastion."
                echo "Usage: cloudfuzzer send-docker-data <path-to-docker-data-directory>"
                echo "Directory must contain two files: docker-image and docker-arguments."
                echo "docker-image: docker save <image> | gzip > docker-image"
                echo "docker-arguments: file must contain docker run arguments: docker run <arguments>"
            else
                $CLOUDFUZZER_DIR/scripts/send-docker-data.sh ${@:2}
            fi
        ;;
        "bastion")
            is_bastion_env_set || return 1;
            ssh $SSH_OPTS $BASTION_USER@$BASTION_ADDRESS "scripts/helpers.sh ${@:2}"
        ;;
        "ssh")
            if [ "$2" == "help" ]; then
                echo "ssh to bastion"
            else
                is_bastion_env_set || return 1;
                ssh $SSH_OPTS $BASTION_USER@$BASTION_ADDRESS    
            fi
        ;;
        "get-results")
            if [ "$2" == "help" ]; then
                echo "Get results from cloudfuzzer"
                echo "Usage: cloudfuzzer get-results <destination-directory>"
            else
                is_bastion_env_set || return 1;
                cloudfuzzer bastion get-results
                $CLOUDFUZZER_DIR/scripts/get-directory.sh results $2
            fi
        ;;
        "get-stats")
            if [ "$2" == "help" ]; then
                echo "Get status and logs from cloudfuzzer"
                echo "Usage: cloudfuzzer get-stats <destination-directory>"
            else
                is_bastion_env_set || return 1;
                cloudfuzzer bastion get-stats
                $CLOUDFUZZER_DIR/scripts/get-directory.sh stats $2
            fi
        ;;
        "help")
        	echo "Available commands:"
            echo "  bastion <command> - run <command> on bastion."
            echo "  create-keys - create new vm-keys"
            echo "  get-results - get results from cloudfuzzer"
            echo "  get-stats - get various stats and logs from cloudfuzzer fuzzvm docker"
            echo "  help - print this"
            echo "  send-docker-data <directory> - send docker data directory to bastion"
            echo "  ssh - ssh to bastion"
        ;;
        *)
            echo "  Unknown argument."
        ;;
    esac
}
