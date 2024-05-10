#!/bin/bash

# Get the PIDs of all softirq threads
pids=$(ps -eLo pid,comm | grep softirq | awk '{print $1}')

# Monitor the CPU utilization of these PIDs
for pid in $pids
do
    pidstat -p $pid 1 > "softirq_logs/softirq_$pid.log" &
done
