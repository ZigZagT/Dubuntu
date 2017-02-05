FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ARG INSTALL_PACKAGES="man git vim curl wget iputils-ping zsh make bzip2"
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
	(sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || exit 0) && \
	dircolors -b ~/.dircolors >> ~/.zshrc

COPY ./robbyrussell.zsh-theme /root/.oh-my-zsh/themes/robbyrussell.zsh-theme

CMD ["zsh"]