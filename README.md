# Cloudfuzzer

Cloudfuzzer is a cloud fuzzing framework. This project is currently in early development stage. Purpose of cloudfuzzer is to make it possible to easily run automated fuzz-testing in cloud environment.

## Setup

### ssh-keys

Packer is used to provision ssh keys to the bastion and fuzzvm images.

By default keys should be named bastion-key, bastion-key.pub and fuzzvm-key, fuzzvm-key.pub and should locate in folder ./vm-keys.

You can use ./scripts/create-keys.sh to create rsa 4096 keys for you.

Keys are provisioned so that bastion can access all machines created from fuzzvm-image, and fuzzvm can access all other fuzzvms and bastion.
(Currently there are no separate users for different operations, so you get full root access with these keys.)

## Using Packer

Using Google Compute Engine with Packer is documented in: https://www.packer.io/docs/builders/googlecompute.html

By default, packer files for bastion and fuzzvm use use_variables for account_file and project_id.

One way to use them is to make a separate json-file:
```
{
    "account_file":	"/path/to/your/account_file.json",
    "project_id":	"your_cloudfuzzer_project_id"
    "aws_access_key": "access_key",
    "aws_secret_key": "secret_key"
}
```

and run Packer build with:

Google Cloud
```
packer build -only=gcloud -var-file=/path/to/your/variables.json packer-bastion.json
```

AWS
```
packer build -only=aws -var-file=/path/to/your/variables.json packer-bastion.json
```

You can use -force if you want Packer to rewrite existing images in cloud platform.

You must create
* N fuzzvm
* 1 bastion


## Setting it up

* ssh bastion "scripts/setup-swarm <nodes>"
* docker save <img> | ssh bastion "scripts/distribute-docker-image.sh"

## Images description

Bastion
* Works as a SSH gateway between outside world and fuzzing cluster
* Delivers docker image from user to swarm-machines
* Stores results

FuzzImage
* Works as a golden image for docker swarm machines
* Contains all required components to run as a docker swarm-master, or as a swarm-node
* In initialization N swarm-machine instances are created from FuzzImage, one of them is selected as a swarm-master, by Bastion
* Can be used in Google Compute Preemptible instances and Amazon Spot Instances.

swarm-master:
* Uses docker-machine to set up docker-swarm, including all swarm-machine instances
* Runs docker swarm discovery service
* Distributes fuzzing jobs, once received from Bastion

swarm-node:
* Runs fuzzing docker container(s)
* Syncs results with Bastion
* Time interval
* Preemptible and SpotInstance shutdown detection

# Requirements:
* [Packer](https://www.packer.io/) 0.11.0
* Cloud service

# Note

Cloudfuzzer nodes are not supposed to be visible in public network. No TLS is used in them and docker daemon can be accessed from network. They should be connected via bastion.


License
----
MIT
