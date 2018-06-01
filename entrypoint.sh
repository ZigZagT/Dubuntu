#!/bin/bash
set -x
set -e

mkdir -p /var/run/sshd
mkdir -p /shared

if [ -f /shared/sources.list ]; then cp -f /shared/sources.list /etc/apt/sources.list; fi
if [ -n "$APT_SOURCE" ]; then
	if [ -f "/etc/apt/sources.list.$APT_SOURCE" ]; then
		cp -f "/etc/apt/sources.list.$APT_SOURCE" /etc/apt/sources.list
	fi
fi
if [ -n "$APT_PACKAGES" ]; then
	apt-get install -y $APT_PACKAGES
fi

# if [ -f /shared/zsh_history ]; then ln -sf /shared/zsh_history /root/.zsh_history; fi
if [ -f /shared/resolv.conf ]; then cat /shared/resolv.conf > /etc/resolv.conf; fi
if [ -f /shared/authorized_keys ]; then
	mkdir -p /root/.ssh
	cp -f /shared/authorized_keys /root/.ssh/authorized_keys
	chmod 644 /root/.ssh/authorized_keys
fi
if [ -f /shared/dircolors ]; then dircolors -b /shared/dircolors > /root/.dircolors_source; fi

if [ ! -f /shared/ssh_host_rsa_key ]; then
	ssh-keygen -f /shared/ssh_host_rsa_key -N '' -t rsa
	rm -f /shared/ssh_host_rsa_key.pub
fi
cp -f /shared/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key

if [ -n "$UNMINIMIZE" ]; then
	expect -c 'spawn unminimize; expect "Would you like to continue"; send y\n; expect "Do you want to continue"; send y\n; interact'
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
