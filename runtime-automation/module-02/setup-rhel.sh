#!/bin/sh
echo "Starting module called module-02" >> /tmp/progress.log
podman rm -f $(podman ps -aq) 2>/dev/null || true
