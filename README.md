# Dubuntu

This is an ubuntu virtual machine enviroment running in docker.

## Build

### From Docker Hub

Pull the image from [Docker Hub](https://hub.docker.com/r/4oranges/dubuntu/) directly.

### Manual Setup

Execute `run.sh` to build the image, and create the container.

`run.sh` script uses `docker-compose` and does these things:
- Build / Rebuild the image if needed
- Create / Recreate the container if needed
- Startup the container

## Connect to VM

Run 

> `docker exec -it dubuntu zsh`

or

> `ssh root@127.0.0.1`

If you desired to use ssh, you should replace the `authorized_keys` with your own keys before build, or manually set the key in container.

## What's inside

- Ubuntu 16.04 kernel 4.9.4
- basic network utils like telnet, ping, etc.
- lsb
- ssh server
- oh my zsh
- docker engine

check the `Dockerfile` to get more detail about the installed packages.

## TODO

- Setup python dev environment
- Setup node.js dev environment
- Basic web server environment
