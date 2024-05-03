#!/bin/bash

sudo docker built -t cpu_experiment .
sudo docker run -it --rm cpu_experiment
