#!/bin/bash

set -eu

my_dir="$(dirname $(readlink -f $0))"
if echo "$my_dir" | grep -E '/holoocean_tools(/.*)?' >/dev/null 2>&1
then
    HOLOOCEAN_DIR="$(echo "$my_dir" | sed -E 's#/holoocean_tools(/.*)?$##')"
else
    echo "Unable to detect HoloOcean base folder: $my_dir"
    exit 1
fi

HOLOOCEAN_HOST_USER_ID=${HOLOOCEAN_HOST_USER_ID:-$UID}
HOLOOCEAN_HOST_USER_NAME=${HOLOOCEAN_HOST_USER_NAME:-$USER}
HOLOOCEAN_TOOLS_IN_DOCKER=/holoocean/holoocean_tools

function docker_build() {
    docker build --network=host --no-cache $@
}

function docker_run() {
    docker run --network=host --rm -e HOST_USER_ID=$HOLOOCEAN_HOST_USER_ID -e HOST_USER_NAME=$HOLOOCEAN_HOST_USER_NAME -e TZ=$(cat /etc/timezone) -v $HOLOOCEAN_DIR:/holoocean $@
}

function holoocean_base_image() {
    docker_build -t holoocean_base_image_iron:latest --build-arg HOST_USER_ID=$HOLOOCEAN_HOST_USER_ID -f ./Dockerfile ./
}

function unreal_build() {
    docker_run holoocean_base_image_iron:latest $HOLOOCEAN_TOOLS_IN_DOCKER/docker/build_unreal.sh $@
}

function holoocean_sim_build() {
    docker_run -e HOLODECKPATH=/holoocean/worlds holoocean_base_image_iron:latest $HOLOOCEAN_TOOLS_IN_DOCKER/docker/build_holoocean_develop.sh $@
}

scriptname="$0"
tasks=$(cat $scriptname | grep '^function' | grep -v docker_run | grep -v docker_build | sed 's/function \([a-z][a-z_]*\).*/\1/')

tasks_to_run=""
skipping=1
startfrom="${1:-}"
custom_parameter="${2:-}"

if [ "$startfrom" = "help" ]
then
    echo "Usage: $0 help | [starting_task_name]"
    echo "Available tasks: $tasks"
    exit 1
fi

for f in $tasks
do
    if [ $skipping -eq 1 ] && [ "$startfrom" != "" ]
    then
        if [ "$f" != "$startfrom" ]
        then
            echo "Skipping $f"
            continue
        fi
        skipping=0
    fi
    tasks_to_run="$tasks_to_run $f"
    if [ "$custom_parameter" = "selected_only" ]
    then
        echo "Only selected task build: $f"
        break
    fi
done

for f in $tasks_to_run
do
 $f
done