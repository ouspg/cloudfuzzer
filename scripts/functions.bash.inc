#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

create-keys () {
"$DIR/create-keys.sh"
}

gce-setup () {
"$DIR/gce-setup.sh" $@
}

send-docker-data () {
"$DIR/send-docker-data.sh" $@
}
