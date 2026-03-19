#!/bin/sh
echo "Starting module called module-03" >> /tmp/progress.log
rm -rf /home/rhel/webapp
podman rm -f webapp-test 2>/dev/null || true
podman rmi webapp:v1 2>/dev/null || true

# Create webapp directory
mkdir -p /home/rhel/webapp
cd /home/rhel/webapp