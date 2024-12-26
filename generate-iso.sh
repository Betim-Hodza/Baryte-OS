#!/bin/bash
set -euo pipefail

# Variables
IMAGE_NAME="baryte-os"
REGISTRY="ghcr.io/betim-hodza"
VERSION="latest"
ISO_NAME="baryte-os-$(date +%Y%m%d)"
VOLID="BARYTE_OS"

# Create a workspace directory
WORKSPACE=$(mktemp -d)
cd "$WORKSPACE"

# Clone the isogenerator
git clone https://github.com/ublue-os/isogenerator.git
cd isogenerator

# Build the ISO generator image
podman build -t isogenerator .

# Generate the ISO
podman run --rm -v "$WORKSPACE":/export \
    --privileged \
    --security-opt label=disable \
    -e IMAGE_NAME="$REGISTRY/$IMAGE_NAME:$VERSION" \
    -e VOLID="$VOLID" \
    -e ISO_NAME="$ISO_NAME" \
    localhost/isogenerator:latest

# Move the ISO to your current directory
mv "$WORKSPACE"/*.iso baryte-os-isos/

# Cleanup
rm -rf "$WORKSPACE"

echo "ISO has been created and placed in baryte-os-isos/"
