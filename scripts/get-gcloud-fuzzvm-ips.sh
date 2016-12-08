#!/bin/bash

gcloud compute instances list | grep fuzzvm | awk '{print $5}' | xargs
