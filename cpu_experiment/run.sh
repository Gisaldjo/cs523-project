#!/bin/bash

# check if image exists
if [ "$1" != "--force" ] && sudo docker images | grep -q cpu_experiment; then
    echo "Image exists"
else
    echo "Building image"
    sudo docker build -t cpu_experiment .
fi
CONTAINER_ID=$(sudo docker run --cpus=4 -d --rm cpu_experiment)

# find the container pid
# CONTAINER_PID=$(sudo docker inspect -f '{{.State.Pid}}' $CONTAINER_ID)
# cat /proc/$CONTAINER_PID/cgroup
echo cpu.max
cat /sys/fs/cgroup/system.slice/docker-$CONTAINER_ID.scope/cpu.max
sudo docker logs $CONTAINER_ID > logs/output.log
