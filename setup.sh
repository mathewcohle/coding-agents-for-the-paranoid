#!/bin/bash
set -e

echo "🔨 Building credentials container..."
podman build -t claude-code-credentials -f Dockerfile.credentials .

echo "⏳ Running container to generate credentials..."
podman run -it claude-code-credentials

# Extract the credentials
echo "📦 Extracting credentials..."
CONTAINER_ID=$(podman ps -a -q --filter ancestor=claude-code-credentials | head -1)
podman cp $CONTAINER_ID:/root/.claude.json ./credentials/.claude.json
podman cp $CONTAINER_ID:/root/.claude/ ./credentials/.claude
podman rm $CONTAINER_ID

# Build the final image
echo "🔨 Building final image with embedded credentials..."
podman build -t claude-code .

echo "✅ Done! Run with: podman run -it --rm claude-code"
