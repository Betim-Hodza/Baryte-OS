#!/bin/bash
# do a clean build
./build.sh
# run it in podman and connect it to bash shell
podman run -it localhost/baryte-os:latest /bin/bash

