# Docker VM

This is an ubuntu virtual machine enviroment running in docker.

## Build

Execute `install.sh` to start build the image and create the container.

## Start VM

Run `docker start docker-vm` to start the VM

## Login to VM

Run 

> `docker exec -it docker-vm zsh`

or

> `ssh root@127.0.0.1`

If you desired to use ssh, put your ssh key in `authorized_keys` before build the vm.

## What's inside

- basic ubuntu environment with apt package manager and kernel 4.9.4
- lsb
- ssh server
- oh my zsh
- docker engine

check the `Dockerfile` to get more detail about the installed packages.

## TODO

- Setup python dev environment
- Setup node.js dev environment
- Basic web server environment
- Use build tools to generate `Dockerfile` dynamically