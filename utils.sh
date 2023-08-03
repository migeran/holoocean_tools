#!/bin/bash

function run_holoocean() {
    my_dir="$PWD"
    if echo "$my_dir" | grep -E '/holoocean_tools(/.*)?' >/dev/null 2>&1
    then
        HOLOOCEAN_DIR="$(echo "$my_dir" | sed -E 's#/holoocean_tools(/.*)?$##')"
    else
        echo "Unable to detect Holo Ocean base folder: $my_dir"
        exit 1
    fi

    export GPU=""
    if [ "$(which nvidia-smi)" != "" ] && [ "$(nvidia-smi -L)" != "" ]
    then
        export GPU="--gpus all"
    fi

    docker run -i -t --rm --name holoocean_builder \
                -e HOST_USER_ID=$(id -u) \
                -e HOST_GROUP_ID=$(id -g) \
                -e HOST_USER_NAME=$(id -un) \
                -e HOST_GROUP_NAME=$(id -gn) \
                -e ROS_MASTER_URI=http://localhost:11311/ \
                -e DISPLAY=$DISPLAY \
                -e TZ=$(cat /etc/timezone) \
                -e QT_X11_NO_MITSHM=1 \
                -e NVIDIA_VISIBLE_DEVICES="all" \
                -e NVIDIA_DRIVER_CAPABILITIES="all" \
                -e HOLODECKPATH=/holoocean/worlds \
                -v $HOLOOCEAN_DIR:/holoocean \
                -v /dev/bus/usb:/dev/bus/usb \
                -v /dev/dri:/dev/dri \
                -v /run/udev/control:/run/udev/control \
                -v /tmp/.X11-unix:/tmp/.X11-unix \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -v /etc/ssl:/etc/ssl \
                -v /:/host \
                --device /dev/ttyACM0:/dev/ttyACM0 \
                --device /dev/dri:/dev/dri \
                --ipc host \
                --network host \
                $GPU \
                --privileged \
                holoocean_base_image_iron:latest $1
}

echo Utility functions loaded