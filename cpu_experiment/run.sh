#!/bin/bash

# check if image exists
if [ "$1" != "--force" ] && sudo docker images | grep -q cpu_experiment; then
    echo "Sysbench Image exists"
else
    echo "Building Sysbench image"
    sudo docker build -t cpu_experiment .
fi
CURR_TIME=$(date)
CONTAINER_ID=$(sudo docker run --cpus=4 -d --rm cpu_experiment)

# echo cpu.max
# cat /sys/fs/cgroup/system.slice/docker-$CONTAINER_ID.scope/cpu.max

if [ -n "$1" ] && [ "$1" != "--force" ]; then
    echo $CURR_TIME > logs/sysbench_$1.log
    echo "--------------------" >> logs/sysbench_$1.log
    sudo docker logs --follow $CONTAINER_ID >> logs/sysbench_$1.log
else
    echo $CURR_TIME > logs/sysbench.log
    echo "--------------------" >> logs/sysbench.log
    sudo docker logs --follow $CONTAINER_ID >> logs/sysbench.log
fi
