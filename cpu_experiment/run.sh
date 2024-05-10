#!/bin/bash

# File path
file=".index.txt"

# Check if file exists and is not empty
if [ -s "$file" ]
then
    # Read the number from the file
    index=$(<"$file")
    # Increment the number
    ((index++))
else
    # Initialize index if file does not exist or is empty
    index=1
fi

# Write the new index back to the file
echo "$index" > "$file"

if [ ! -d "data" ]; then
    mkdir data
fi


sudo docker build -t cpu_experiment .
# sudo docker built -t cpu_experiment .

sudo docker run -it --rm cpu_experiment >> "data/run_$index.log"
