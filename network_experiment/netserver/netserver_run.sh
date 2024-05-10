#!/bin/bash

tc qdisc add dev eth0 handle 1: ingress
tc filter add dev eth0 parent ffff: protocol ip prio 50 u32 match ip src 0.0.0.0/0 police rate 800mbit burst 10k drop flowid :1
tc qdisc add dev eth0 root tbf rate 800mbit latency 25ms burst 10k

if [ -n "$1" ] && [ "$1" != "--force" ]; then
    log_path="/logs/netserver_$1.log"
else
    log_path="/logs/netserver.log"
fi
netserver -D > $log_path
