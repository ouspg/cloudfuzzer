# Cloudfuzzer

Cloudfuzzer is a cloud fuzzing framework. This project is currently in early development stage.

Packer creates following images:

## Bastion
* Works as a SSH gateway between outside world and fuzzing cluster
* Delivers docker image from user to swarm-machines
* Stores results

## FuzzImage
* Works as a golden image for docker swarm machines
* Contains all required components to run as a docker swarm-master, or as a swarm-node
* In initialization N swarm-machine instances are created from FuzzImage, one of them is selected as a swarm-master, by Bastion
* Can be used in Google Compute Preemptible instances and Amazon Spot Instances.

### swarm-master:
* Uses docker-machine to set up docker-swarm, including all swarm-machine instances
* Runs docker swarm discovery service
* Distributes fuzzing jobs, once recieved from Bastion

### swarm-node:
* Runs fuzzing docker container(s)
* Syncs results with Bastion
* Time interval
* Preemptible and SpotInstance shutdown detection

## Setup

### ssh-keys

Packer is used to provision ssh keys to the bastion and fuzzvm images.

By default keys should be named bastion-key, bastion-key.pub and fuzzvm-key, fuzzvm-key.pub and should locate in folder ./vm-keys.

You can use ./scripts/create-keys.sh to create rsa 4096 keys for you.

Keys are provisioned so that bastion can access all machines created from fuzzvm-image, and fuzzvm can access all other fuzzvms and bastion.
(Currently there are no separate users for different operations, so you get full root access with these keys.)

### Google Compute Engine for Packer

Using Google Compute Engine with Packer is documented in: https://www.packer.io/docs/builders/googlecompute.html

By default, packer files for bastion and fuzzvm use use_variables for account_file and project_id.

One way to use them is to make a separate json-file:

{
	"account_file":	"/path/to/your/account_file.json",
	"project_id":	"your_cloudfuzzer_project_id"
}

and run Packer build with:

packer build -var-file=/path/to/your/variables.json packer-bastion.json

# Requirements:
* [Packer](https://www.packer.io/) 0.11.0

