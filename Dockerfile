FROM ubuntu:20.04

ARG UID=1000
ARG GID=1000
ARG USERNAME="user"
ARG TZ="Asia/Taipei"

ENV INSTALLATION_TOOLS apt-utils \
    curl \
    software-properties-common

ENV DEVELOPMENT_PACKAGES python3.8 \
    python3-pip

ENV TOOL_PACKAGES bash \
    dos2unix \
    git \
    locales \
    nano \
    tree \
    vim \
    sudo \
    wget

ENV USER ${USERNAME}
ENV TERM xterm-256color
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE DontWarn

# install system packages
RUN apt-get -qq update && \
    apt-get -qq install ${INSTALLATION_TOOLS} && \
    # prerequisite - git
    add-apt-repository ppa:git-core/ppa && \
    # start install
    apt-get -qq update && \
    apt-get -qq upgrade && \
    apt-get -qq install ${DEVELOPMENT_PACKAGES} ${TOOL_PACKAGES}

# install python libraries
COPY ./config/requirements.txt /tmp/requirements.txt
RUN pip3 install --upgrade pip && \
    pip3 install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# setup time zone
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# add support of locale zh_TW
RUN sed -i 's/# en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen && \
    sed -i 's/# zh_TW.UTF-8/zh_TW.UTF-8/g' /etc/locale.gen && \
    sed -i 's/# zh_TW BIG5/zh_TW BIG5/g' /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# add non-root user account
RUN groupadd -o -g ${GID} ${USERNAME} && \
    useradd -u ${UID} -m -s /bin/bash -g ${GID} ${USERNAME} && \
    echo "${USERNAME} ALL = NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    passwd -d ${USERNAME}

# add scripts and setup permissions
COPY --chown=${UID}:${GID} ./scripts/.bashrc /home/${USERNAME}/.bashrc
COPY --chown=${UID}:${GID} ./scripts/start.sh /docker/start.sh
COPY --chown=${UID}:${GID} ./scripts/login.sh /docker/login.sh
COPY --chown=${UID}:${GID} ./scripts/startup.sh /usr/local/bin/startup
RUN dos2unix -ic "/home/${USERNAME}/.bashrc" | xargs dos2unix && \
    dos2unix -ic "/docker/start.sh" | xargs dos2unix && \
    dos2unix -ic "/docker/login.sh" | xargs dos2unix && \
    dos2unix -ic "/usr/local/bin/startup" | xargs dos2unix && \
    chmod +x "/usr/local/bin/startup"

# user account configuration
RUN mkdir -p /home/${USERNAME}/.ssh && \
    mkdir -p /home/${USERNAME}/.vscode-server && \
    mkdir -p /home/${USERNAME}/projects
RUN chown -R ${UID}:${GID} /home/${USERNAME}

USER ${USERNAME}

WORKDIR /home/${USERNAME}

CMD [ "bash", "/docker/start.sh" ]
