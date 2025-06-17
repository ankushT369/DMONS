#!/bin/bash
set -e

source ../config/config.env

DOCKER="docker"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Starting exporter port (default 9121)
BASE_EXPORTER_PORT=${REDIS_EXPORTER_PORT:-9121}

# Function to launch one exporter
launch_exporter() {
    local redis_port=$1
    local exporter_port=$2
    local cluster_flag=$3
    local container_name="redis_exporter_${redis_port}"
    local redis_url="redis://:${PASSWORD}@${REDIS_HOST}:${redis_port}"

    echo -e "${YELLOW}Launching Redis Exporter → Redis Port: ${redis_port}, Exporter Port: ${exporter_port}${NC}"

    ${DOCKER} run -d --rm --network host \
        --name "${container_name}" \
        -p ${exporter_port}:${exporter_port} \
        ${REDIS_EXPORTER} \
        --redis.addr="${redis_url}" \
        ${cluster_flag} \
        --web.listen-address=":${exporter_port}"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✔ Exporter running (Redis: ${redis_port}, Exporter: ${exporter_port}, Container: ${container_name})${NC}"
    else
        echo -e "${RED}✘ Failed to start exporter for Redis ${redis_port}${NC}"
    fi
}

# Print config info
echo -e "${YELLOW}Detected MODE: ${MODE}${NC}"
echo -e "${YELLOW}Target Host: ${REDIS_HOST}${NC}"
echo -e "${YELLOW}Redis Ports: ${REDIS_PORT}${NC}"
echo -e "${YELLOW}Base Exporter Port: ${BASE_EXPORTER_PORT}${NC}"

# Dispatcher based on mode
case "$MODE" in
    master)
        launch_exporter "${REDIS_PORT}" "${BASE_EXPORTER_PORT}" ""
        ;;

    cluster|sentinel)
        IFS=',' read -r -a PORT_ARRAY <<< "$REDIS_PORT"

        i=0
        for port in "${PORT_ARRAY[@]}"; do
            cluster_flag=""
            [ "$MODE" = "cluster" ] && cluster_flag="--is-cluster"
            launch_exporter "$port" "$((BASE_EXPORTER_PORT + i))" "$cluster_flag"
            ((i++))
        done
        ;;

    *)
        echo -e "${RED}Unsupported MODE: ${MODE}${NC}"
        exit 1
        ;;
esac
