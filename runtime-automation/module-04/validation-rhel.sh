#!/bin/sh
echo "Validated module called module-03" >> /tmp/progress.log

# Validate pod deployment module

# Check if pod exists
if ! podman pod exists webapp-pod; then
    echo "FAIL: webapp-pod does not exist"
    echo "HINT: Create the pod with 'podman pod create --name webapp-pod -p 8080:8080'"
    exit 1
fi

# Check if database container exists in the pod
if ! podman ps --filter "pod=webapp-pod" --filter "name=database" --format "{{.Names}}" | grep -q database; then
    echo "FAIL: database container not found in webapp-pod"
    echo "HINT: Add the database container to the pod following the instructions"
    exit 1
fi

# Check if webapp container exists in the pod
if ! podman ps --filter "pod=webapp-pod" --filter "name=webapp" --format "{{.Names}}" | grep -q webapp; then
    echo "FAIL: webapp container not found in webapp-pod"
    echo "HINT: Add the webapp container to the pod following the instructions"
    exit 1
fi

# Check if both containers are running
db_running=$(podman ps --filter "pod=webapp-pod" --filter "name=database" --filter "status=running" --format "{{.Names}}")
webapp_running=$(podman ps --filter "pod=webapp-pod" --filter "name=webapp" --filter "status=running" --format "{{.Names}}")

if [ -z "$db_running" ]; then
    echo "FAIL: database container is not running"
    echo "HINT: Check the container logs with 'podman logs database'"
    exit 1
fi

if [ -z "$webapp_running" ]; then
    echo "FAIL: webapp container is not running"
    echo "HINT: Check the container logs with 'podman logs webapp'"
    exit 1
fi

# Check if webapp:v2 image exists
if ! podman images | grep -q "webapp.*v2"; then
    echo "FAIL: webapp:v2 image not found"
    echo "HINT: Build the updated image with 'podman build -t webapp:v2 .'"
    exit 1
fi

# Test if the application is accessible
if ! curl -s -f http://localhost:8080 > /dev/null; then
    echo "FAIL: Web application is not accessible on port 8080"
    echo "HINT: Ensure the pod was created with port mapping '-p 8080:8080'"
    exit 1
fi

echo "PASS: Podman pod deployed successfully with database and web application"
