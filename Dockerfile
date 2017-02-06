FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive
ARG INSTALL_PACKAGES="\
	lsb \
	man \
	git \
	vim \
	curl \
	wget \
	zsh \
	make \
	bzip2 \
	mtr \
	openssh-server \
	iputils-ping \
	libnet-ifconfig-wrapper-perl \
	linux-image-extra-4.8.0-35-generic \
	linux-image-extra-virtual \
	apt-transport-https \
	ca-certificates \
	software-properties-common \
"
ARG TERM=xterm-256color
VOLUME /shared
WORKDIR /root

COPY ./sources.list /etc/apt/sources.list
COPY ./dircolors /root/.dircolors
COPY ./authorized_keys /root/.ssh/authorized_keys

RUN apt-get update && \
	apt-get install -y --no-install-recommends apt-utils && \
	apt-get install -y $INSTALL_PACKAGES && \
	apt-get upgrade -y && \
	curl -fsSL https://yum.dockerproject.org/gpg | apt-key add -  && \
	add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main" && \
    apt-get update && \
    apt-get -y install docker-engine && \
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
	dircolors -b ~/.dircolors >> ~/.zshrc && \
	chsh -s /bin/zsh

COPY ./robbyrussell.zsh-theme /root/.oh-my-zsh/themes/robbyrussell.zsh-theme
COPY ./entrypoint.sh /root/.entrypoint.sh

ENTRYPOINT ["/root/.entrypoint.sh"]
