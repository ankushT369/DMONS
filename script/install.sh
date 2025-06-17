#!/bin/bash

# This script installs Docker (if not already installed)
# and pulls the Redis Exporter image.

source ../config/config.env

# Define package manager and Docker/image names
DOCKER="docker"

# Define colors
GREEN='\033[0;32m'   # Success
RED='\033[0;31m'     # Error or important warning
YELLOW='\033[1;33m'  # Info
NC='\033[0m'         # Reset/No color

echo -e "${YELLOW}Checking if Docker is installed...${NC}"

# Check if Docker is installed
if dpkg -s ${DOCKER} &>/dev/null; then
    echo -e "${GREEN}✔ ${DOCKER} is already installed.${NC}"
else
    echo -e "${RED}✘ ${DOCKER} is not installed.${NC}"
    echo -e "${YELLOW}Installing ${DOCKER}...${NC}"
    sudo ${PACKAGE_MANAGER} update
    sudo ${PACKAGE_MANAGER} install -y ${DOCKER}
fi

echo -e "${YELLOW}Checking for Redis Exporter image...${NC}"

# Check and pull Redis Exporter Docker image
if ${DOCKER} image inspect ${REDIS_EXPORTER} &>/dev/null; then
    echo -e "${GREEN}✔ Redis Exporter image is already downloaded.${NC}"
else
    echo -e "${YELLOW}Pulling Redis Exporter image...${NC}"
    ${DOCKER} pull ${REDIS_EXPORTER}
fi

echo -e "${GREEN}✔ All done.${NC}"

