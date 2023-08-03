#!/bin/bash

set -eux

my_dir="$(dirname $(readlink -f $0))"
if echo "$my_dir" | grep -E '/holoocean_tools(/.*)?' >/dev/null 2>&1
then
    HOLOOCEAN_DIR="$(echo "$my_dir" | sed -E 's#/holoocean_tools(/.*)?$##')"
else
    echo "Unable to detect Holo Ocean base folder: $my_dir"
    exit 1
fi

cd $HOLOOCEAN_DIR/holoocean_tools

source utils.sh

run_holoocean $HOLOOCEAN_DIR/holoocean_tools/docker/holoocean_test.sh