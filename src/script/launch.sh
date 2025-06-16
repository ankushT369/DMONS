#! /bin/bash


# This Scripts aims to launch the requires instances for redis expoter

# mode field contains
# - cluster (many redis instances connected with each other)
# - sentinel(single redis instance with replica)
# - master  (single instance only)
set -e

source ../config/config.env

DOCKER="docker"

# Define colors
GREEN='\033[0;32m'   # Success
RED='\033[0;31m'     # Error or important warning
YELLOW='\033[1;33m'  # Info
NC='\033[0m'         # Reset/No color

REDIS_ADDR="redis://:${PASSWORD}@${REDIS_HOST}:${REDIS_PORT}"

echo -e "${YELLOW} Launching Redis Exporter on ${REDIS_EXPORTER_PORT}..."

# Run the Docker container
${DOCKER} run --rm --network host \
    ${REDIS_EXPORTER} \
    --redis.addr="${REDIS_ADDR}" \

# Check the exit status of the docker run
if [ $? -eq 0 ]; then
    echo -e "${GREEN} Redis Exporter ran successfully on port ${REDIS_EXPORTER_PORT}."
else
    echo -e "${RED} Redis Exporter failed or exited unexpectedly."
fi

