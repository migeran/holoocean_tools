#!/bin/bash

set -e

my_dir="$(dirname $(readlink -f $0))"
if echo "$my_dir" | grep -E '/holoocean_tools(/.*)?' >/dev/null 2>&1
then
    HOLOOCEAN_DIR="$(echo "$my_dir" | sed -E 's#/holoocean_tools(/.*)?$##')"
else
    echo "Unable to detect Holo Ocean base folder: $my_dir"
    exit 1
fi

source /holoocean/holooceanvenv/bin/activate
set +u
source /opt/ros/iron/setup.bash

cd /holoocean/holoocean_ros
source install/setup.bash
set -u

cd src/py_ros2_holoocean/launch/
ros2 launch point_cloud_visualization_test.launch.py