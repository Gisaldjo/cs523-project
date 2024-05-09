#!/bin/bash

# Stop all running containers
sudo docker stop $(sudo docker ps -aq)

# Delete all containers
sudo docker rm $(sudo docker ps -aq)

# Delete all images
sudo docker rmi $(sudo docker images -q)

if [ "$1" == "--logs" ]; then
    rm -f cpu_experiment/logs/*
    rm -f network_experiment/logs/*
fi
