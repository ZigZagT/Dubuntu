FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm-256color
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y \
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
        dnsutils \
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
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" \
    && apt-get update \
    && apt-get install docker-ce -y \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && rm -f /etc/ssh/ssh_host_*_key

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
    chsh -s /bin/zsh
COPY zshrc /root/.zshrc
COPY dubuntu.zsh-theme /root/.oh-my-zsh/custom/dubuntu.zsh-theme

COPY dircolors /root/.dircolors
RUN dircolors -b /root/.dircolors > /root/.dircolors_source

COPY authorized_keys /root/.ssh/authorized_keys

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

VOLUME /shared
WORKDIR /root
EXPOSE 22 80
CMD ["/entrypoint.sh"]
