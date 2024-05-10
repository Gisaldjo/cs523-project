#!/bin/bash

# Check if the netserver container is running; if not, start it
if [ "$(sudo docker ps -q -f name=netserver)" ]; then
    echo "Netserver is already running."
else
    echo "Netserver is not running."
    if [ "$1" != "--force" ] && sudo docker images | grep -q netserver_image; then
        echo "Netserver Image exists"
    else
        echo "Netserver Image does not exist"
        sudo docker build -t netserver_image netserver/
    fi
    if [ -n "$1" ] && [ "$1" != "--force" ]; then
        sudo docker run -v $PWD/logs:/logs -d --rm --name=netserver -p 12865:12865 --cap-add=NET_ADMIN netserver_image $1
    else
        sudo docker run -v $PWD/logs:/logs -d --rm --name=netserver -p 12865:12865 --cap-add=NET_ADMIN netserver_image
    fi
fi

sleep 2
unset NETSERVER_IP

# Get the IP address of the netserver container
NETSERVER_IP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' netserver)
echo "Netserver IP: $NETSERVER_IP"

if [ "$1" != "--force" ] && sudo docker images | grep -q netperf_image; then
    echo "Netperf Image exists"
else
    echo "Netperf Image does not exist"
    sudo docker build -t netperf_image netperf_client/
fi

# Start the netperf client containers
if [ -n "$1" ] && [ "$1" != "--force" ]; then
    end_range=$1
else
    end_range=8
fi

for i in $(seq 1 $end_range)
do
    if [ -n "$1" ] && [ "$1" != "--force" ]; then
        CONTAINER_ID=$(sudo docker run -v $PWD/logs:/logs -d --rm --cap-add=NET_ADMIN netperf_image -- $i $1 -H $NETSERVER_IP -l 64 -t TCP_STREAM -- -m 64)
    else
        CONTAINER_ID=$(sudo docker run -v $PWD/logs:/logs -d --rm --cap-add=NET_ADMIN netperf_image -- $i -H $NETSERVER_IP -l 64 -t TCP_STREAM -- -m 64)
    fi
    # ../tc_limits.sh $CONTAINER_ID
done
