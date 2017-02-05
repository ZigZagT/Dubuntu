FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ARG INSTALL_PACKAGES="lsb man git vim curl wget zsh make bzip2 libnet-ifconfig-wrapper-perl mtr linux-image-extra-4.8.0-35-generic linux-image-extra-virtual apt-transport-https ca-certificates software-properties-common"
ARG TERM=xterm-256color
VOLUME /shared
WORKDIR /root

COPY ./sources.list /etc/apt/sources.list
COPY ./dircolors /root/.dircolors

RUN PACKAGES="man git vim curl wget iputils-ping zsh" && \
	apt-get update && \
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
	(sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || exit 0) && \
	dircolors -b ~/.dircolors >> ~/.zshrc

COPY ./robbyrussell.zsh-theme /root/.oh-my-zsh/themes/robbyrussell.zsh-theme

CMD ["zsh"]