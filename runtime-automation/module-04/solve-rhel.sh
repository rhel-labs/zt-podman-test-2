#!/bin/sh
echo "Solved module called module-03" >> /tmp/progress.log


cd /home/rhel/webapp || exit 1

echo "=== Solution for Deploying a Podman Pod ==="
echo ""

echo "Step 1: Create the pod"
podman pod create --name webapp-pod -p 8080:8080
echo ""

echo "Step 2: Add database container to the pod"
podman run -d \
  --pod webapp-pod \
  --name database \
  -e POSTGRESQL_USER=webapp \
  -e POSTGRESQL_PASSWORD=secret \
  -e POSTGRESQL_DATABASE=webappdb \
  registry.redhat.io/rhel9/postgresql-13:latest
echo ""

echo "Step 3: Create updated application with database support"
cat > app.py << 'EOF'
from flask import Flask
import psycopg2
import os

app = Flask(__name__)

def get_db_connection():
    try:
        conn = psycopg2.connect(
            host='localhost',
            database='webappdb',
            user='webapp',
            password='secret'
        )
        return conn
    except Exception as e:
        return None

@app.route('/')
def hello():
    db_status = "Connected" if get_db_connection() else "Not Connected"

    return '''
    <html>
        <body>
            <h1>Hello from Podman Pod!</h1>
            <p>This web application is running in a Podman pod.</p>
            <p>Hostname: {}</p>
            <p>Database Status: {}</p>
        </body>
    </html>
    '''.format(os.uname().nodename, db_status)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
EOF

cat > requirements.txt << 'EOF'
Flask==3.0.0
psycopg2-binary==2.9.9
EOF
echo ""

echo "Step 4: Build updated image"
podman build -t webapp:v2 .
echo ""

echo "Step 5: Add webapp container to the pod"
podman run -d \
  --pod webapp-pod \
  --name webapp \
  webapp:v2
echo ""

echo "Step 6: Wait for services to start"
sleep 5
echo ""

echo "Step 7: Test the application"
curl -s http://localhost:8080 | head -15
echo ""

echo "Step 8: Show pod status"
podman pod ps
podman ps --pod
echo ""

echo "Step 9: Generate Kubernetes YAML"
podman generate kube webapp-pod > webapp-pod.yaml
echo "Kubernetes YAML saved to webapp-pod.yaml"
echo ""

echo "=== Module completed successfully ==="
