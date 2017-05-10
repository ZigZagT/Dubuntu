# Docker VM

This is an ubuntu virtual machine enviroment running in docker.

## Run

Execute `run.sh` to create the VM.

`run.sh` script uses `docker-compose` and does these things:
- Build / Rebuild the image if needed
- Create / Recreate the container if needed
- Startup the container

## Connect to VM

Run 

> `docker exec -it Dobuntu zsh`

or

> `ssh root@127.0.0.1`

If you desired to use ssh, replace the `authorized_keys` with your own keys before build the vm.

## What's inside

- Ubuntu 16.04 kernel 4.9.4
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