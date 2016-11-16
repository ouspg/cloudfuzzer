#!/bin/bash

gcloud compute instances list | grep fuzzvm | awk '{print $4}' | xargs
