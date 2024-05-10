CONTAINER_ID=$1
PID=$(sudo docker inspect -f '{{.State.Pid}}' $CONTAINER_ID)
PEER=$(sudo nsenter -t $PID -n ethtool -S eth0 | grep peer_ifindex | awk '{print $2}')
# Find the veth interface
VETH=$(ip link | grep $PEER | awk -F: '{print $2}' | awk -F@ '{print $1}')
# Now you can apply tc commands to the veth interface
sudo tc qdisc add dev $VETH handle 1: ingress
sudo tc filter add dev $VETH parent ffff: protocol ip prio 50 u32 match ip src 0.0.0.0/0 police rate 30mbit burst 10k drop flowid :1
sudo tc qdisc add dev $VETH root tbf rate 30mbit latency 25ms burst 10k
