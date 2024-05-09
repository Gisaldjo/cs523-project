#!/bin/bash

# Check if the netserver container is running; if not, start it
if [ "$(sudo docker ps -q -f name=netserver)" ]; then
    echo "Netserver is already running."
else
    echo "Netserver is not running."
    if [ "$1" != "--force" ] && sudo docker images | grep -q netserver_image; then
        echo "Image exists"
    else
        echo "Image does not exist"
        sudo docker build -t netserver_image netserver/
    fi
    sudo docker run -v $PWD/logs:/logs -d --rm --name=netserver -p 12865:12865 --cap-add=NET_ADMIN netserver_image
fi

sleep 2
unset NETSERVER_IP

# Get the IP address of the netserver container
NETSERVER_IP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' netserver)
echo "Netserver IP: $NETSERVER_IP"

if [ "$1" != "--force" ] && sudo docker images | grep -q netperf_image; then
    echo "Image exists"
else
    echo "Image does not exist"
    sudo docker build -t netperf_image netperf_client/
fi

# Start the netperf client containers
for i in {1..8}
do
    sudo docker run -v $PWD/logs:/logs -d --rm --cap-add=NET_ADMIN netperf_image -- $i -H $NETSERVER_IP -l 64 -t TCP_STREAM -- -m 64
done
