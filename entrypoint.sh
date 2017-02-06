#!/bin/bash

service ssh start
service docker start

# keep the container alive
while true; do
	sleep 100
done
echo "exit container"
