# Dubuntu

[![Build Status](https://travis-ci.org/BananaWanted/Dubuntu.svg)](https://travis-ci.org/BananaWanted/Dubuntu) [![Docker Stars](https://img.shields.io/docker/stars/bananawanted/dubuntu.svg)](https://hub.docker.com/r/bananawanted/dubuntu/) [![Docker Pulls](https://img.shields.io/docker/pulls/bananawanted/dubuntu.svg)](https://hub.docker.com/r/bananawanted/dubuntu/) 

A user-friendly, versatile, portable ubuntu toolbox in docker.

## What's Inside
- Ubuntu bionic (18.04LTS)
- basic network utils like telnet, ping, etc.
- lsb
- ssh server
- oh my zsh
- docker engine (docker in docker)
- python2 and python3
- ...


## Installation
```bash
git clone https://github.com/BananaWanted/Dubuntu
cd Dubuntu
# Install command line tools into /usr/local/bin
./install
```

## Command Line Reference

#### `dubuntu-pull`
Pull the latest image from docker hub

### Daemon Mode Commands
Run `Dubuntu` in background as a daemon

#### `dubuntu-build`
Build the image locally

#### `dubuntu-recreate`
Recreate / restart Dubuntu

#### `dubuntu-attach`
Attatch to running Dubuntu

#### start / stop container
Use `docker start dubuntu` and `docker stop dubuntu`

### Normal Mode Commands
Run `Dubuntu` as a disposible container

#### `dubuntu-run`
Launch dubuntu in current terminal as a disposible container, attach with `zsh`.

You may add `-v <dir>:/shared/<dir>` to the end of this command to mount something into the container.

## Recipes
### Change Docker Settings
Any docker related settings are defined in `docker-compose.yaml`. Simply add port mapping / volumes as you wish.

### Connect to Dubuntu via SSH
```bash
# make sure you are in side the Dubuntu directory
# And port 22 is mapped in `docker-compose.yaml` correctly
cat ~/.ssh/id_rsa.pub >> shared/authorized_keys
dubuntu-recreate
ssh root@localhost	# or somewhere you defined
```

### Clean up danling images after rebuild
`docker rmi $(docker images -q -f dangling=true)`

### Move Dubuntu Git Repo to Another Location
simply re-run `install.sh`

## Configurations
Priority: ENV > Conf files

### Config via Environment
- APT_SOURCE=< tuna | official >
- APT_PACKAGES=< additional package list seprated by space >
- UNMINIMIZE=true	# invoke command `unminimize` in official ubuntu image at container start time.

### Configuration Files
Put files listed below inside `/shared` to override corresponding files inside the container.
- `sources.list`: override `/etc/apt/sources.list` in VM.
- `resolv.conf`: override `/etc/resolv.conf` in VM.
- `authorized_keys`: override `/root/.ssh/authorized_keys` in VM.
- `dircolors`: override color mapping of the inside console.
- `profile`: addition `zsh` startup source script.
- `ssh_host_rsa_key`: override /etc/ssh/ssh_host_rsa_key, the host rsa key. Will be generated automatically if not exists.
- `zsh_history`: override `/root/.zsh_history` in VM.

## Known Issues
- Because Docker for Mac is running in a real virtual machine([hyperkit](https://github.com/moby/hyperkit)), after a long sleep, the hyperkit may have its clock drift, which may cause the ssh connection fails. restart the container to workaround.
- `/shared/zsh_history` currently not working

## TODO
- Option for setup node.js dev environment
- Optional for setup basic web server environment
- Add to Homebrew
- Utilize Makefile to manage the mess
- Follow [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html) for config file
- Add alpine based branch to reduce image size
