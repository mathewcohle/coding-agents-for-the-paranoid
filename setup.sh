#!/bin/bash
set -e

echo "🧹 Clean previous build..."
read -p "⚠️ Delete 'credentials/' and all contents? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm ./credentials/.claude.json || true
  rm -r ./credentials/.claude || true
else
  echo "Setup process cancelled"
  exit 1
fi

podman rmi -i claude-code claude-code-credentials

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
