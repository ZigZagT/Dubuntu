FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive
ARG INSTALL_PACKAGES="\
    lsb \
    man \
    git \
    telnet \
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
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    supervisor \
    supervisor-doc \
    launchtool \
    python \
    python-pip \
    python3 \
    python3-pip \
"
ARG TERM=xterm-256color
VOLUME /shared
WORKDIR /root
EXPOSE 22

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y $INSTALL_PACKAGES
RUN apt-get update \
    && apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
    && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" \
    && apt-get update \
    && apt-get install docker-ce
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
    chsh -s /bin/zsh

COPY zshrc /root/.zshrc

COPY dircolors /root/.dircolors
RUN dircolors -b /root/.dircolors > /root/.dircolors_source

COPY dubuntu.zsh-theme /root/.oh-my-zsh/custom/dubuntu.zsh-theme
COPY authorized_keys /root/.ssh/authorized_keys
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
