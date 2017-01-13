#!/bin/bash

#Docker swarm manager address
BASTION_ADDRESS=$(cat $HOME/bastion_master);

rsync -avz /home/ubuntu/results ubuntu@BASTION_ADDRESS:/home/ubuntu/results
