#!/bin/bash
set -oeux pipefail

# Build the image
podman build -t baryte-os .

# Tag with version
podman tag baryte-os:latest ghcr.io/YOUR_USERNAME/baryte-os:latest