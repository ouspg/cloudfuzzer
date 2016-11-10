#!/bin/bash

#usage: upload-dockerimage.sh <bastion> <fuzzvm1> <fuzzvm2> ...

ADDRESSES="$@"

echo "Bastion: $1"

## Todo: this must be modified, it's currently very slow and does same job multiple times

for i in ${@:2}
do
    echo "FuzzVM: $i"
    docker save testi/myapp  | gzip  | pv | ssh ubuntu@$1 "cat | pv | ssh $i \"docker load\" "
done
