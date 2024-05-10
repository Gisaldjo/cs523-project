#!/bin/bash

tc qdisc add dev eth0 handle 1: ingress
tc filter add dev eth0 parent ffff: protocol ip prio 50 u32 match ip src 0.0.0.0/0 police rate 30mbit burst 10k drop flowid :1
tc qdisc add dev eth0 root tbf rate 30mbit latency 25ms burst 10k

if [ -n "$2" ] && [ "$2" != "-H" ]; then
    log_path="/logs/netperf_$2_$1.log"
else
    log_path="/logs/netperf_$1.log"
fi

echo "$(date)________START_________" > $log_path
if [ -n "$2" ] && [ "$2" != "-H" ]; then
    netperf ${@:3} >> $log_path
else
    netperf ${@:2} >> $log_path
fi
echo "$(date)________DONE_________" >> $log_path
