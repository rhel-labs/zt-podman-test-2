#!/bin/sh
echo "Validated module called module-02" >> /tmp/progress.log
if ! command -v podman &> /dev/null; then
    echo "FAIL: Podman is not installed"
    echo "HINT: Run 'dnf install podman' to install Podman"
    exit 1
fi

# Check if UBI minimal image exists
if ! podman images | grep -q "ubi9/ubi-minimal"; then
    echo "FAIL: UBI minimal image not found"
    echo "HINT: Run 'podman run --rm registry.access.redhat.com/ubi9/ubi-minimal:latest echo \"test\"' to download the image"
    exit 1
fi

echo "PASS: Podman is installed and working correctly"