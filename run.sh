#!/usr/bin/env bash

IMAGE_NAME="docker-vm"
CONTAINER_NAME="docker-vm"
REBUILD=true


remove_container_if_exists() {
	if [[ $(docker ps -a --no-trunc --filter name=^/$CONTAINER_NAME$ -q | wc -l) -eq 1 ]]; then
		docker rm -f $CONTAINER_NAME
	fi
}

build_image() {
	docker build -t $IMAGE_NAME .
}

create_and_run() {
	echo trying to run $CONTAINER_NAME
	docker run --privileged=true --name docker-vm -d -v $(pwd)/shared:/shared -p 127.0.0.1:22:22 docker-vm
}

restart_and_run() {
	echo "go away" 
}

clear_images() {
	docker rmi $(docker images -qa -f "dangling=true")
}

if [[ $REBUILD ]]; then
	remove_container_if_exists
	build_image
	create_and_run
else
	echo "not support yet"
fi

clear_images
