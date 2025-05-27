#!/bin/bash

if [ $# -ne 1 ]; then
    echo -e "Usage: config.sh <samples>\n\nsamples\t\tThe number of samples\n"
    exit 1
fi

#Script creating a configuration to aim for blocks of 8 MiB
SAMPLES=$1

ROWS=$(echo "8388608 / (($SAMPLES + 7) / 8)" | bc)
echo "samples = $SAMPLES"
echo "bitvectorsperblock = $ROWS"
echo "preset = 3" #Default Zstd preset

#Preset level is not taken into account right now, and default level is always used
#Default preset is 3.
