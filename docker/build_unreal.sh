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

cd $HOLOOCEAN_DIR/UnrealEngine
./Setup.sh
./GenerateProjectFiles.sh
make UE4Editor-Linux-Debug