#!/bin/bash

set -eux

CONTAINER="${1:-holoocean_builder}"

docker exec -i -t \
            -e DISPLAY=$DISPLAY \
            -e QT_X11_NO_MITSHM=1 \
            -t $CONTAINER \
            /entrypoint.sh /bin/bash
