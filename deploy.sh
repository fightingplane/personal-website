#!/bin/bash

# Deploy script for Hugo personal website
# Stops existing container, builds new image, and starts it

set -e

echo "🚀 Deploying Hugo Personal Website..."

# Stop and remove existing container if it exists
if docker ps -a | grep -q "personal-website"; then
    echo "🛑 Stopping existing container..."
    docker stop personal-website 2>/dev/null || true
    docker rm personal-website 2>/dev/null || true
fi

# Build the Docker image
echo "🏗️  Building Docker image..."
docker build -t personal-website .

# Run the new container
echo "🐳 Starting new container on port 8081..."
docker run -d --name personal-website -p 8081:8081 personal-website

echo "✅ Deployment complete!"
echo "🌐 Your site is available at: http://localhost:8081"
echo "📋 To stop the container: docker stop personal-website"
echo "🔄 To redeploy after changes: ./deploy.sh"