#!/bin/bash

# Check if the netserver container is running; if not, start it
if [ "$(sudo docker ps -q -f name=netserver)" ]; then
    echo "Netserver is already running."
else
    echo "Netserver is not running."
    sudo docker run  -itd --rm --name=netserver -p 12865:12865 networkstatic/netserver -D
fi

sleep 2
unset NETSERVER_IP

# Get the IP address of the netserver container
NETSERVER_IP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' netserver)
echo "Netserver IP: $NETSERVER_IP"
# Start the netperf client container
sudo docker run  -it --rm networkstatic/netperf -H $NETSERVER_IP
