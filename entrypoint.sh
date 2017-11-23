#!/bin/bash

mkdir /var/run/sshd
mkdir -p /shared

if [ -f /shared/sources.list ]; then ln -sf /shared/sources.list /etc/apt/sources.list; fi
if [ -f /shared/resolv.conf ]; then ln -sf /shared/resolv.conf /etc/resolv.conf; fi
if [ -f /shared/authorized_keys ]; then
	mkdir -p /root/.ssh
	ln -sf /shared/authorized_keys /root/.ssh/authorized_keys
	chmod 644 /root/.ssh/authorized_keys
fi
if [ -f /shared/dircolors ]; then dircolors -b /shared/dircolors > /root/.dircolors_source; fi
for f in "$(ls /shared/ssh_host_*_key)"; do
	local key_file_name=$(basename "$f")
	ln -sf "/shared/$key_file_name" "/etc/ssh/$key_file_name"
done

/usr/bin/supervisord
