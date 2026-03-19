#!/bin/sh
echo "Validated module called module-03" >> /tmp/progress.log
# Validate Containerfile module

# Check if webapp directory exists
if [ ! -d "/home/rhel/webapp" ]; then
    echo "FAIL: /home/rhel/webapp directory not found"
    echo "HINT: Create the directory with 'mkdir -p ~/webapp && cd ~/webapp'"
    exit 1
fi

# Check if Containerfile exists
if [ ! -f "/home/rhel/webapp/Containerfile" ]; then
    echo "FAIL: Containerfile not found in /home/rhel/webapp"
    echo "HINT: Create a Containerfile following the instructions in the lab"
    exit 1
fi

# Check if the webapp:v1 image exists
if ! podman images | grep -q "webapp.*v1"; then
    echo "FAIL: webapp:v1 image not found"
    echo "HINT: Build the image with 'podman build -t webapp:v1 .'"
    exit 1
fi

# Check if app.py exists
if [ ! -f "/home/rhel/webapp/app.py" ]; then
    echo "FAIL: app.py not found in /home/rhel/webapp"
    echo "HINT: Create app.py following the instructions"
    exit 1
fi

echo "PASS: Container image built successfully"
