# Cloudfuzzer

Cloudfuzzer is a cloud fuzzing framework. This project is currently in early development stage.

Packer creates following images:

1. Bastion
⋅⋅* Works as a SSH gateway between outside world and fuzzing cluster
⋅⋅* Delivers docker image from user to swarm-machines
⋅⋅* Stores results

2. FuzzImage
⋅⋅* Works as a golden image for docker swarm machines
⋅⋅* Contains all required components to run as a docker swarm-master, or as a swarm-node
⋅⋅* In initialization N swarm-machine instances are created from FuzzImage, one of them is selected as a swarm-master, by Bastion
⋅⋅* Can be used in Google Compute Preemptible instances and Amazon Spot Instances.

⋅⋅* swarm-master:
⋅⋅⋅* Uses docker-machine to set up docker-swarm, including all swarm-machine instances
⋅⋅⋅* Runs docker swarm discovery service
⋅⋅⋅* Distributes fuzzing jobs, once recieved from Bastion

⋅⋅* swarm-node:
⋅⋅⋅* Runs fuzzing docker container(s)
⋅⋅⋅* Syncs results with Bastion
⋅⋅⋅* Time interval
⋅⋅⋅* Preemptible and SpotInstance shutdown detection

# Requirements:
* [Packer](https://www.packer.io/) 0.11.0
