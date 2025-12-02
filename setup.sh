#!/bin/bash
set -e

echo "🧹 Clean previous build..."
read -p "⚠️ Delete 'credentials/.gemini' and all contents? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -r ./credentials/.gemini/ || true
else
  echo "Setup process cancelled"
  exit 1
fi

podman rmi -i gemini-code gemini-code-credentials

echo "🔨 Building credentials container..."
podman build -t gemini-code-credentials -f Dockerfile.credentials .

echo "⏳ Running container to generate credentials..."
podman run -it gemini-code-credentials

# Extract the credentials
echo "📦 Extracting credentials..."
CONTAINER_ID=$(podman ps -a -q --filter ancestor=gemini-code-credentials | head -1)
podman cp $CONTAINER_ID:/root/.gemini/ ./credentials/.gemini
podman rm $CONTAINER_ID

# Build the final image
echo "🔨 Building final image with embedded credentials..."
podman build -t gemini-code .

echo "✅ Done! Run with: podman run -it --rm gemini-code"
