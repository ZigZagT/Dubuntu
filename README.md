# Dubuntu

This is a ubuntu virtual machine enviroment running in docker.

## Installation
### Pulling from DockerHub
```bash
docker pull 4oranges/dubuntu
```

### Or Build it Locally
```bash
git clone https://github.com/4Oranges/Dubuntu.git && cd Dubuntu
./build.sh
```

## Usage
### Boot VM
```bash
# make sure you are in side the Dubuntu directory
cat ~/.ssh/id_rsa.pub >> shared/authorized_keys
./start.sh
```

### Connect to VM
```bash
ssh root@127.0.0.1
```
### Change VM Settings
Having setting files in the [shared](shared) folder will help this trick.


## What's Inside

- Ubuntu xenial (16.04)
- basic network utils like telnet, ping, etc.
- lsb
- ssh server
- oh my zsh
- docker engine
- python2 and python3

check the `Dockerfile` to get more detail about the installed packages.

## TODO
- Setup node.js dev environment
- Basic web server environment
