#!/bin/bash

# Limit all incoming and outgoing network to 30mbit/s
tc qdisc add dev eth0 handle 1: ingress
tc filter add dev eth0 parent ffff: protocol ip prio 50 u32 match ip src 0.0.0.0/0 police rate 30mbit burst 10k drop flowid :1
tc qdisc add dev eth0 root tbf rate 30mbit latency 25ms burst 10k

echo "________START_________" > /logs/netperf_$1.log
netperf ${@:2} >> /logs/netperf_$1.log
echo "________DONE_________" >> /logs/netperf_$1.log