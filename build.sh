#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Check if version number is provided
if [ -z "$1" ]; then
    echo "Error: Version number is required"
    echo "Usage: ./build.sh <version>"
    echo "run: ./build.sh 1.86.2"
    exit 1
fi

VERSION=$1

# Validate version format (basic semver check)
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Warning: Version '$VERSION' doesn't follow semver format (x.y.z)"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Building Docker images..."
sudo docker compose build

echo "Tagging images with version $VERSION..."
sudo docker tag sudosu404/tailnet:latest sudosu404/tailnet:$VERSION

echo "Pushing images to registry..."
# Push in parallel for efficiency using background processes
sudo docker push sudosu404/tailnet:latest &
sudo docker push sudosu404/tailnet:$VERSION &

# Wait for all background jobs to complete
wait

echo "✓ Successfully built and pushed version $VERSION"
echo "Images pushed:"
echo "  - sudosu404/tailnet:latest"
echo "  - sudosu404/tailnet:$VERSION"