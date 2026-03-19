#!/bin/sh
echo "Solved module called module-02" >> /tmp/progress.log
echo "=== Solution for Installing Podman ==="
echo ""
echo "Step 1: Check Podman version"
podman --version
echo ""

echo "Step 2: Run test container"
podman run --rm registry.access.redhat.com/ubi9/ubi-minimal:latest echo "Podman is working!"
echo ""

echo "Step 3: List images"
podman images
echo ""

echo "Step 4: Check Podman storage location"
podman info --format "{{.Store.GraphRoot}}"
echo ""

echo "=== Module completed successfully ==="