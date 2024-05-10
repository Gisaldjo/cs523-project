#!/bin/bash

timestamp=$(date +"%Y-%m-%d_%H%M%S")

mkdir logs/mixed_$timestamp
mv cpu_experiment/logs/* logs/$timestamp/
mv network_experiment/logs/* logs/$timestamp/
mv output.log logs/$timestamp/
