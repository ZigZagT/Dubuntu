# Dubuntu

[![Build Status](https://travis-ci.org/4Oranges/Dubuntu.svg)](https://travis-ci.org/4Oranges/Dubuntu) [![Docker Stars](https://img.shields.io/docker/stars/4oranges/dubuntu.svg)](https://hub.docker.com/r/4oranges/dubuntu/) [![Docker Pulls](https://img.shields.io/docker/pulls/4oranges/dubuntu.svg)](https://hub.docker.com/r/4oranges/dubuntu/) 

A handy ubuntu enviroment in docker.

## Installation
### Pull from DockerHub
```bash
docker pull 4oranges/dubuntu
```

### Or Build it Locally
```bash
git clone https://github.com/4Oranges/Dubuntu.git && cd Dubuntu
./build.sh
```

## Usage
### Boot/Restart VM
```bash
# make sure you are in side the Dubuntu directory
cat ~/.ssh/id_rsa.pub >> shared/authorized_keys
./start.sh
```

### Connect to VM
```bash
ssh root@localhost
```

### Change VM Settings
Put files listed below inside `/shared` to override corresponding settings. 
- `sources.list`: override `/etc/apt/sources.list` in VM.
- `resolv.conf`: override `/etc/resolv.conf` in VM.
- `authorized_keys`: override `/root/.ssh/authorized_keys` in VM.
- `dircolors`: override color mapping of the inside console.
- `profile`: addition `zsh` startup source script.
- `ssh_host_rsa_key`: override /etc/ssh/ssh_host_rsa_key, the host rsa key. Will be generated automatically if not exists.


## What's Inside
- Ubuntu xenial (16.04)
- basic network utils like telnet, ping, etc.
- lsb
- ssh server
- oh my zsh
- docker engine
- python2 and python3
- ...

## Know Issues
- Because Docker for Mac is running in a real virtual machine([hyperkit](https://github.com/moby/hyperkit)), after a long sleep, the hyperkit may have its clock drift, which may cause the ssh connection fails. Re-run `./start.sh` to workaround.

## TODO
- Setup node.js dev environment
- Basic web server environment

