#!/bin/bash
set -e

mkdir -p /var/run/sshd
mkdir -p /shared

if [[ -f /shared/sources.list ]]; then
    echo "using apt source /shared/sources.list"
    cp -f /shared/sources.list /etc/apt/sources.list
fi
if [[ -n "$APT_SOURCE" && -f "/etc/apt/sources.list.$APT_SOURCE" ]]; then
    echo "apt source is reset to $APT_SOURCE"
    cp -f "/etc/apt/sources.list.$APT_SOURCE" /etc/apt/sources.list
fi
if [[ -n "$APT_PACKAGES" ]]; then
    echo "installing packages $APT_PACKAGES"
    apt-get update
	apt-get install -y $APT_PACKAGES
fi

# if [[ -f /shared/zsh_history ]]; then ln -sf /shared/zsh_history /root/.zsh_history; fi
if [[ -f /shared/resolv.conf ]]; then
    echo "using dns setting /shared/resolv.conf"
    cat /shared/resolv.conf > /etc/resolv.conf
fi
if [[ -f /shared/authorized_keys ]]; then
    echo "using ssh key /shared/authorized_keys"
	mkdir -p /root/.ssh
	cp -f /shared/authorized_keys /root/.ssh/authorized_keys
	chmod 644 /root/.ssh/authorized_keys
fi
if [[ -f /shared/dircolors ]]; then
    echo "using dircolors /shared/dircolors"
    dircolors -b /shared/dircolors > /root/.dircolors_source
fi

if [[ ! -f /shared/ssh_host_rsa_key ]]; then
    echo "regenerating server ssh key, and save to /shared/ssh_host_rsa_key"
	ssh-keygen -f /shared/ssh_host_rsa_key -N '' -t rsa
	rm -f /shared/ssh_host_rsa_key.pub
fi
cp -f /shared/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key

if [[ -n "$UNMINIMIZE" ]]; then
    echo "unminimize ubuntu"
	expect -c 'spawn unminimize; expect "Would you like to continue"; send y\n; expect "Do you want to continue"; send y\n; interact'
fi

echo Dubuntu start up process completed
echo ======================================================================

if [[ -n "$@" ]]; then
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
    exec "$@"
else
    /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
fi

