#!/bin/bash
set -euo pipefail

# Variables
IMAGE_NAME="baryte-os"
VERSION="latest"

# Build the image
echo "Building $IMAGE_NAME..."
podman build \
    --rm \
    --force-rm \
    --pull \
    -t "localhost/${IMAGE_NAME}:${VERSION}" \
    .

echo "Build completed successfully!"

# Optionally run the container
if [[ "${1:-}" == "--run" ]]; then
    echo "Running container..."
    podman run -it --rm "localhost/${IMAGE_NAME}:${VERSION}" /bin/bash
fi
