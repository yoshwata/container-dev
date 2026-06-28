#!/usr/bin/env bash

# Docker Compose build script for docker-compose-local-dind-mac.yaml
# This script builds images in the correct order based on their dependencies

set -e  # Exit immediately if a command exits with a non-zero status

COMPOSE_FILE="settings/docker-compose-local-dind-mac.yaml"
ORIGINAL_DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"
DOCKER_CONFIG_TMP="$(mktemp -d)"
trap 'rm -rf "$DOCKER_CONFIG_TMP"' EXIT

# Avoid host-specific credential helpers during public image pulls.
printf '{}' > "$DOCKER_CONFIG_TMP/config.json"

# Keep the compose CLI plugin available while isolating registry auth config.
if [ -x "$ORIGINAL_DOCKER_CONFIG/cli-plugins/docker-compose" ]; then
    mkdir -p "$DOCKER_CONFIG_TMP/cli-plugins"
    ln -sf "$ORIGINAL_DOCKER_CONFIG/cli-plugins/docker-compose" \
        "$DOCKER_CONFIG_TMP/cli-plugins/docker-compose"
fi

echo "========================================="
echo "Building Docker images in dependency order"
echo "========================================="
echo ""

# Function to build a service
build_service() {
    local service=$1
    echo ">>> Building: $service"
    DOCKER_CONFIG="$DOCKER_CONFIG_TMP" docker compose -f "$COMPOSE_FILE" build "$service"
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
DOCKER_CONFIG="$DOCKER_CONFIG_TMP" docker images | grep yoshwata
