#!/bin/bash

timestamp=$(date +"%Y-%m-%d_%H%M%S")
prefix=${1:-v2}

mkdir logs/${prefix}_mixed_$timestamp
mv cpu_experiment/logs/* logs/${prefix}_mixed_$timestamp/
mv network_experiment/logs/* logs/${prefix}_mixed_$timestamp/
mv output.log logs/${prefix}_mixed_$timestamp/
