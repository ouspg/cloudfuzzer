# Cloudfuzzer

Cloudfuzzer is a cloud fuzzing framework. This project is currently in early development stage.

Packer creates following images:

# Bastion
* Works as a SSH gateway between outside world and fuzzing cluster
* Delivers docker image from user to swarm-machines
* Stores results

# FuzzImage
* Works as a golden image for docker swarm machines
* Contains all required components to run as a docker swarm-master, or as a swarm-node
* In initialization N swarm-machine instances are created from FuzzImage, one of them is selected as a swarm-master, by Bastion
* Can be used in Google Compute Preemptible instances and Amazon Spot Instances.

# Requirements:
* [Packer](https://www.packer.io/) 0.11.0
