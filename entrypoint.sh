#!/bin/bash

service ssh start
service docker start
# mkdir -p /var/run/sshd
# /usr/sbin/sshd -D
# /usr/bin/dockerd -p /var/run/docker.pid &

# keep the container alive
while true; do
	sleep 100
done
echo "exit container"
