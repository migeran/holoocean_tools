#!/bin/bash

set -e

my_dir="$(dirname $(readlink -f $0))"
if echo "$my_dir" | grep -E '/holoocean_tools(/.*)?' >/dev/null 2>&1
then
    HOLOOCEAN_DIR="$(echo "$my_dir" | sed -E 's#/holoocean_tools(/.*)?$##')"
else
    echo "Unable to detect HoloOcean base folder: $my_dir"
    exit 1
fi

HOLOOCEAN_ROS_DIR="$HOLOOCEAN_DIR/holoocean_ros"
SONAR_DATA_PROCESSOR_DIR="$HOLOOCEAN_ROS_DIR/src/sonar_data_processor"
HOLODECK_VERSION="0.5.0"

cd $HOLOOCEAN_DIR
python -m venv /holoocean/holooceanvenv # to initialize the virtual environment
source /holoocean/holooceanvenv/bin/activate # to enter the virtual environment

python -m pip install holoocean
python -m pip install pynput # HoloOcean dependencies
python -m pip install pyaml
python -c 'import holoocean; holoocean.install("Ocean")'
cp -r /holoocean/holoocean_tools/custom_worlds/* $HOLODECKPATH/$HOLODECK_VERSION/worlds/Ocean/
python -m pip install catkin_pkg
python -m pip install empy
python -m pip install lark
python -m pip install matplotlib
python -m pip install pytest # pybind11 dependencies
python -m pip install scipy
python -m pip install pybind11

cd $SONAR_DATA_PROCESSOR_DIR
python -m pip install -e . --verbose

cd $HOLOOCEAN_ROS_DIR
. /opt/ros/iron/setup.bash
colcon build