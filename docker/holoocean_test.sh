#!/bin/bash

set -eu

my_dir="$(dirname $(readlink -f $0))"
if echo "$my_dir" | grep -E '/holoocean_tools(/.*)?' >/dev/null 2>&1
then
    HOLOOCEAN_DIR="$(echo "$my_dir" | sed -E 's#/holoocean_tools(/.*)?$##')"
else
    echo "Unable to detect Holo Ocean base folder: $my_dir"
    exit 1
fi

source /holoocean/holooceanvenv/bin/activate

python <<EOF
import holoocean
import numpy as np

env = holoocean.make("Dam-Hovering")

# The hovering AUV takes a command for each thruster
command = np.array([10,10,10,10,0,0,0,0])

for _ in range(5000):
   state = env.step(command)
EOF