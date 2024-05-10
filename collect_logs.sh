#!/bin/bash

timestamp=$(date +"%Y-%m-%d_%H%M%S")

mkdir logs/mixed_$timestamp
mv cpu_experiment/logs/* logs/mixed_$timestamp/
mv network_experiment/logs/* logs/mixed_$timestamp/
mv output.log logs/mixed_$timestamp/
