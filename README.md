# Cloudfuzzer

Cloudfuzzer is a cloud fuzzing framework. Purpose of cloudfuzzer is to make it possible to easily run automated fuzz-testing in cloud environment.

In cloud environment __bastion__ instance works as a SSH gateway between outside world and fuzzing cluster. It is used to deliver docker image from user to swarm machines. Bastion is also used for storing fuzzing results.

__Fuzzvm__ instances consist of __one__ __swarm-master__ and __N__ __swarm-nodes__. Swarm-master is used to set up docker-swarm, including all swarm-machine instances. It distributes fuzzing jobs, once received from Bastion. Swarm-nodes run fuzzing docker containers and sync results with bastion. Swarm-nodes can be run as Preemptible/SpotInstance instances because they have shutdown detection and they sync results before shutdown.

# Getting started

## Example script for GCE

Example script for setup in GCE is found in [tests/gce-tests/gce-setup.sh](tests/gce-tests/gce-setup.sh)

## config files

Config file of cloudfuzzer is named cloudfuzzer.conf
user.conf overrides cloudfuzzer.conf.

Following variables are used:
```
BASTION_ADDRESS="xxx.xxx.xxx.xxx" # IP address of bastion
SSH_OPTS="-o StrictHostKeyChecking=no -i $CLOUDFUZZER_DIR/vm-keys/bastion-key" # SSH options
BASTION_USER="ubuntu" # Bastion username
```
## cloudfuzzer

Use following command to source cloudfuzzer functions
```
$ source scripts/functions.bash.inc
```

Available commands (usage: cloudfuzzer &lt;command&gt;):
```
bastion <command> - run <command> on bastion.
create-keys - create new vm-keys
get-results - get results from cloudfuzzer
get-stats - get various stats and logs from cloudfuzzer fuzzvm docker
help - print this
send-docker-data <directory> - send docker data directory to bastion
ssh - ssh to bastion
```

To get help for specific command type
```
$ cloudfuzzer <command> help
```

## ssh-keys

Packer is used to provision ssh keys to the bastion and fuzzvm images.

By default keys should be named bastion-key, bastion-key.pub and fuzzvm-key, fuzzvm-key.pub and should locate in folder ./vm-keys.

You can use following command to create rsa 4096 keys for you.

```
$ cloudfuzzer create-keys
```

Keys are provisioned so that bastion can access all machines created from fuzzvm-image, and fuzzvm can access all other fuzzvms and bastion.
(Currently there are no separate users for different operations, so you get full root access with these keys.)

## Images

Packer is used for creating images to cloud environment. You must build images for bastion and fuzzvm. You find the packer files from [packer/](packer/) directory.

By default, packer files for bastion and fuzzvm use use_variables for account_file and project_id. One way to use them is to make a separate json-file:
```
{
    "account_file":	"/path/to/your/account_file.json",
    "project_id":	"your_cloudfuzzer_project_id"
}
```

After that you can build images with following commands (Google Cloud)

__Bastion__
```
$ packer build -only=gcloud -var-file=/path/to/your/variables.json packer-bastion.json
```

__Fuzzvm__
```
$ packer build -only=gcloud -var-file=/path/to/your/variables.json packer-fuzzvm.json
```

* If you want to use aws use -only=aws
* You can use -force if you want Packer to rewrite existing images in cloud platform.
* Using Google Compute Engine with Packer: https://www.packer.io/docs/builders/googlecompute.html

## Instances

After creating images with packer you should setup running instances in cloud environment.
* 1x bastion
* Nx fuzzvm

Bastion should have access public ip so it can be accessed from outside network while fuzzvm should only have internal network ip.

## Setting it up

```
$ cloudfuzzer bastion setup-swarm <nodes>
```

List of ip addresses of nodes should be given as argument for setup-swarm.sh

## Distributing docker image

Save docker image to cloudfuzzer/context :
```
$ docker save $image | gzip > cloudfuzzer/context/docker-image
```

Docker arguments should be defined in context/docker-options  
Example:
```
 -d -m 3g volume_container_rsync
```

Upload context:
```
$ send-docker-data cloudfuzzer/context
```

## Run containers

Run number of containers

```
$ cloudfuzzer bastion run-containers <count>
```

## Get results

Get results from fuzzvm's. If no ip-adresses are given as argument results from all fuzzvm's are fetched.

```
$ cloudfuzzer bastion get-results (fuzzvm1) (fuzzvm2) ...
```

## Get stats

Get stats

```
$ cloudfuzzer get-stats <destionation>
docker service list
ID            NAME                    MODE        REPLICAS  IMAGE
nsbg1dh6t2k1  fuzz-service            replicated  70/70     p7zip-fuzz
xl3l65kufl66  rsync-volume-container  global      10/10     nabeken/docker-volume-container-rsync

docker service inspect fuzz-service --pretty

ID:             nsbg1dh6t2k1biiroyf92oukf
Name:           fuzz-service
Service Mode:   Replicated
 Replicas:      70
Placement:
UpdateConfig:
 Parallelism:   1
 On failure:    pause
 Max failure ratio: 0
ContainerSpec:
 Image:         p7zip-fuzz
Mounts:
  Target = /output
   Source = rsync-volume-container
   ReadOnly = false
   Type = volume
Resources:
 Reservations:
  Memory:       500 MiB
Endpoint Mode:  vip

docker service ps fuzz-service
ID            NAME             IMAGE       NODE       DESIRED STATE  CURRENT STATE        ERROR  PORTS
7iadtdvc3dsc  fuzz-service.1   p7zip-fuzz  fuzzvm-8   Running        Running 2 hours ago         
81qsodiixxee  fuzz-service.2   p7zip-fuzz  fuzzvm-6   Running        Running 2 hours ago
```


# Requirements

* [Packer](https://www.packer.io/) 0.11.0
* Cloud service

License
----
Apache 2.0
