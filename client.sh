#!/bin/bash

WS_DIR=$(cd "$(dirname "$0")/.." && pwd)

DATA_VOLUME_NAME="/home/zhangkai1/share"
CONTAINER_NAME="s3_client"
IMAGE_NAME="ubuntu:latest"

function log_info {
    echo -e "[\e[1;32mINFO\e[0m] $1"
}

function log_warn {
    echo -e "[\e[1;33mWARN\e[0m] $1"
}

function log_error {
    echo -e "[\e[1;31mERROR\e[0m] $1"
}

function assert {
    if [ $? -ne 0 ]; then
        log_error "$2, code $1"
        exit $1
    fi
}

function show_banner {
    echo -e "\e[1;33m"
    echo -e "   s3_server"
    echo -e "\e[0m"
}

function docker_create {
    # Create data volume
    log_info "Create container..."

    # Create container
    docker run \
        --name=$CONTAINER_NAME \
        --network=host \
        --volume=$DATA_VOLUME_NAME:/mnt/host \
        --tty \
        --interactive \
        --env-file ./env.list \
        $IMAGE_NAME \
        bash

    assert $? "Container create failed"
}

function docker_run {
    # Try create container
    has_jarvis=$(docker ps -a | awk {'print $NF'} | grep $CONTAINER_NAME)
    if [ -z "$has_jarvis" ]; then
        docker_create
    fi

    # Try start container
    is_running=$(docker ps | awk {'print $NF'} | grep $CONTAINER_NAME)
    if [ -z "$is_running" ]; then
        docker start $CONTAINER_NAME >/dev/null
        assert $? "Container start failed"
    fi

    # Try start container
    is_running=$(docker ps | awk {'print $NF'} | grep $CONTAINER_NAME)
    if [ -z "$is_running" ]; then
        docker start $CONTAINER_NAME >/dev/null
        assert $? "Container start failed"
    fi
}

function docker_stop {
    log_info "Stopping container..."
    docker stop $CONTAINER_NAME >/dev/null
    assert $? "Container stop failed"
}

function docker_remove {
    # Try stop container
    if [ -n "$(docker ps | awk {'print $NF'} | grep $CONTAINER_NAME)" ]; then
        docker_stop
    fi

    log_info "Delete container..."
    docker rm $CONTAINER_NAME >/dev/null
    assert $? "Container remove failed"
}

function docker_update {
    # Try delete container
    if [ -n "$(docker ps -a | awk {'print $NF'} | grep $CONTAINER_NAME)" ]; then
        docker_remove
    fi

    log_info "Updating jarvis development..."
    docker pull $IMAGE_NAME
    assert $? "Docker image update failed"
    cd $WS_DIR && git pull
    assert $? "Jarvis development update failed"
}


clear
show_banner

if [ "$1" == "run" ]; then
    docker_run
elif [ "$1" == "restart" ]; then
    docker_stop
    docker_run
elif [ "$1" == "stop" ]; then
    docker_stop
elif [ "$1" == "remove" ]; then
    docker_remove
elif [ "$1" == "update" ]; then
    docker_update
else
    log_info "run       - create or run container"
    log_info "restart   - restart container"
    log_info "stop      - stop container"
    log_info "remove    - delete container without persistent volume"
    log_info "update    - pull latest docker image and recreate container"
    log_info "help      - show this content"
fi

