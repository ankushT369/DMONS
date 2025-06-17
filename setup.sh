#!/bin/bash

set -e

CONFIG_ENV_PATH="config/config.env"
REDIS_CONF_PATH="/etc/redis/redis.conf"
INSTALL_SCRIPT="script/install.sh"
LAUNCH_SCRIPT="script/launch.sh"

cleanup() {
    echo -e "\nCtrl+C detected. Cleaning up..."

    CONTAINER_ID=$(docker ps --filter ancestor=oliver006/redis_exporter --format "{{.ID}}")
    if [ -n "$CONTAINER_ID" ]; then
        echo "Stopping Redis Exporter container $CONTAINER_ID..."
        docker stop "$CONTAINER_ID"
    fi

    echo "Exiting setup."
    exit 1
}

trap cleanup INT

check_redis_installed() {
    if ! command -v redis-server &> /dev/null; then
        echo "Redis not found. Installing Redis..."
        sudo apt update
        sudo apt install -y redis-server
    else
        echo "Redis is already installed."
    fi

    echo "Starting Redis..."
    sudo systemctl enable redis-server
    sudo systemctl start redis-server
}

extract_password_from_redis_conf() {
    if [[ ! -f "$REDIS_CONF_PATH" ]]; then
        echo "Redis config file not found at $REDIS_CONF_PATH"
        exit 1
    fi

    REDIS_PASSWORD=$(grep '^requirepass' "$REDIS_CONF_PATH" | awk '{print $2}')
    if [[ -z "$REDIS_PASSWORD" ]]; then
        echo "Password not found in redis.conf"
        exit 1
    fi

    echo "Extracted Redis password: $REDIS_PASSWORD"
}

update_config_env_password() {
    if [[ ! -f "$CONFIG_ENV_PATH" ]]; then
        echo "$CONFIG_ENV_PATH does not exist"
        exit 1
    fi

    sed -i "s/^PASSWORD=.*/PASSWORD=$REDIS_PASSWORD/" "$CONFIG_ENV_PATH"
    echo "Updated PASSWORD in config.env"
}

run_project_scripts() {
    echo "Running install.sh"
    chmod +x "$INSTALL_SCRIPT"
    (cd "$(dirname "$INSTALL_SCRIPT")" && ./$(basename "$INSTALL_SCRIPT"))

    echo "Running launch.sh"
    chmod +x "$LAUNCH_SCRIPT"
    (cd "$(dirname "$LAUNCH_SCRIPT")" && ./$(basename "$LAUNCH_SCRIPT"))
}

main() {
    check_redis_installed
    extract_password_from_redis_conf
    update_config_env_password
    run_project_scripts
}

main

