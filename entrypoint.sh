#!/bin/bash
set -e

# copied from https://github.com/jpetazzo/dind/blob/master/wrapdocker<Paste>

# Ensure that all nodes in /dev/mapper correspond to mapped devices currently loaded by the device-mapper kernel driver
dmsetup mknodes

# First, make sure that cgroups are mounted correctly.
CGROUP=/sys/fs/cgroup
: {LOG:=stdio}

[ -d $CGROUP ] ||
	mkdir $CGROUP

mountpoint -q $CGROUP ||
	mount -n -t tmpfs -o uid=0,gid=0,mode=0755 cgroup $CGROUP || {
		echo "Could not make a tmpfs mount. Did you use --privileged?"
		exit 1
	}

if [ -d /sys/kernel/security ] && ! mountpoint -q /sys/kernel/security
then
    mount -t securityfs none /sys/kernel/security || {
        echo "Could not mount /sys/kernel/security."
        echo "AppArmor detection and --privileged mode might break."
    }
fi

# Mount the cgroup hierarchies exactly as they are in the parent system.
for SUBSYS in $(cut -d: -f2 /proc/1/cgroup)
do
        [ -d $CGROUP/$SUBSYS ] || mkdir $CGROUP/$SUBSYS
        mountpoint -q $CGROUP/$SUBSYS ||
                mount -n -t cgroup -o $SUBSYS cgroup $CGROUP/$SUBSYS

        # The two following sections address a bug which manifests itself
        # by a cryptic "lxc-start: no ns_cgroup option specified" when
        # trying to start containers withina container.
        # The bug seems to appear when the cgroup hierarchies are not
        # mounted on the exact same directories in the host, and in the
        # container.

        # Named, control-less cgroups are mounted with "-o name=foo"
        # (and appear as such under /proc/<pid>/cgroup) but are usually
        # mounted on a directory named "foo" (without the "name=" prefix).
        # Systemd and OpenRC (and possibly others) both create such a
        # cgroup. To avoid the aforementioned bug, we symlink "foo" to
        # "name=foo". This shouldn't have any adverse effect.
        echo $SUBSYS | grep -q ^name= && {
                NAME=$(echo $SUBSYS | sed s/^name=//)
                ln -s $SUBSYS $CGROUP/$NAME
        }

        # Likewise, on at least one system, it has been reported that
        # systemd would mount the CPU and CPU accounting controllers
        # (respectively "cpu" and "cpuacct") with "-o cpuacct,cpu"
        # but on a directory called "cpu,cpuacct" (note the inversion
        # in the order of the groups). This tries to work around it.
        [ $SUBSYS = cpuacct,cpu ] && ln -s $SUBSYS $CGROUP/cpu,cpuacct
done

# Note: as I write those lines, the LXC userland tools cannot setup
# a "sub-container" properly if the "devices" cgroup is not in its
# own hierarchy. Let's detect this and issue a warning.
grep -q :devices: /proc/1/cgroup ||
	echo "WARNING: the 'devices' cgroup should be in its own hierarchy."
grep -qw devices /proc/1/cgroup ||
	echo "WARNING: it looks like the 'devices' cgroup is not mounted."

# Now, close extraneous file descriptors.
pushd /proc/self/fd >/dev/null
for FD in *
do
	case "$FD" in
	# Keep stdin/stdout/stderr
	[012])
		;;
	# Nuke everything else
	*)
		eval exec "$FD>&-"
		;;
	esac
done
popd >/dev/null

# end copy


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
    /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
    exec "$@"
else
    /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
fi

