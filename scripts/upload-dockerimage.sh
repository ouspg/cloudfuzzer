#!/bin/bash

#usage: upload-dockerimage.sh <docker-image> <bastion>

#example: ./upload-dockerimage.sh <docker-image> <bastion>

echo "Image name: $1"
echo "Bastion: $2"

docker save $1 | ssh ubuntu@$2 "/scripts/distribute-docker-image.sh"
