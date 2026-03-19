#!/bin/sh
echo "Solved module called module-03" >> /tmp/progress.log

cd /home/rhel/webapp || exit 1

echo "=== Solution for Building Container Images ==="
echo ""

echo "Step 1: Create application files"
cat > app.py << 'EOF'
from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return '''
    <html>
        <body>
            <h1>Hello from Podman!</h1>
            <p>This web application is running in a container built with Podman.</p>
            <p>Hostname: {}</p>
        </body>
    </html>
    '''.format(os.uname().nodename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
EOF

cat > requirements.txt << 'EOF'
Flask==3.0.0
EOF

echo "Created app.py and requirements.txt"
echo ""

echo "Step 2: Create Containerfile"
cat > Containerfile << 'EOF'
# Use the official Python base image
FROM registry.access.redhat.com/ubi9/python-39:latest

# Set working directory
WORKDIR /app

# Copy application files
COPY requirements.txt .
COPY app.py .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8080
EXPOSE 8080

# Run the application
CMD ["python", "app.py"]
EOF

echo "Created Containerfile"
echo ""

echo "Step 3: Build the image"
podman build -t webapp:v1 .
echo ""

echo "Step 4: Verify the image"
podman images | grep webapp
echo ""

echo "Step 5: Test the container"
podman run -d --name webapp-test -p 8080:8080 webapp:v1
sleep 3
curl -s http://localhost:8080 | head -10
echo ""

echo "Step 6: Clean up test container"
podman stop webapp-test
podman rm webapp-test
echo ""

echo "=== Module completed successfully ==="
