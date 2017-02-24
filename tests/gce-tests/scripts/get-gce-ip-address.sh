#!/bin/bash

set -o errexit
set -o nounset

#Helper for fetching of gce instance IP addresses.
#Note: This script is for usage with gce-setup.sh, different instance configuration,
#might result return values other than IP addresses.

INSTANCE_NAME_PREFIX=$1;

gcloud compute instances list | awk '$1 ~ /'$INSTANCE_NAME_PREFIX'/ {print $4}' | xargs