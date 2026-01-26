#!/usr/bin/env bash

# Docker Compose build script for docker-compose-local-dind-mac.yaml
# This script builds images in the correct order based on their dependencies

set -e  # Exit immediately if a command exits with a non-zero status

COMPOSE_FILE="settings/docker-compose-local-dind-mac.yaml"

echo "========================================="
echo "Building Docker images in dependency order"
echo "========================================="
echo ""

# Function to build a service
build_service() {
    local service=$1
    echo ">>> Building: $service"
    docker compose -f "$COMPOSE_FILE" build "$service"
    echo "✓ Successfully built: $service"
    echo ""
}

# Build in dependency order
build_service "ubuntu-dev-base-local"
build_service "power-tmux-local"
build_service "nvim-local"
build_service "anyenv-local"
# build_service "nodejs-base-local"
# build_service "nodejs-local"

echo "========================================="
echo "All images built successfully!"
echo "========================================="
echo ""
echo "Built images:"
docker images | grep yoshwata
