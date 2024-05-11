#!/bin/bash

timestamp=$(date +"%Y-%m-%d_%H%M%S")
prefix=${1:-v2}

mkdir logs/${prefix}_$timestamp
mv cpu_experiment/logs/* logs/${prefix}_$timestamp/
mv network_experiment/logs/* logs/${prefix}_$timestamp/
mv output.log logs/${prefix}_$timestamp/
mkdir logs/${prefix}_$timestamp/softirq/
mv softirq_logs/* logs/${prefix}_$timestamp/softirq/
mv cpu_utilization.log logs/${prefix}_$timestamp/
