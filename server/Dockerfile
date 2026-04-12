FROM debian:bookworm

# Mise à jour du système et installation sudo, openssh-client, openssh-server, netcat
RUN apt-get update && apt-get install -y \
    bash-completion \
    curl \
    git \
    htop \
    jq \
    make \
    net-tools \
    netcat-openbsd \
    openssh-client \
    openssh-server \
    procps \
    socat \
    sudo \
    tree \
    unzip \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Configuration du server SSH
RUN mkdir /var/run/sshd

ENV USER=devuser

# Création d'un nouvel utilisateur sans mot de passe
RUN useradd -m ${USER} && echo "${USER}:${USER}" | chpasswd && adduser ${USER} sudo \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devuser \
    && chmod 0440 /etc/sudoers.d/devuser

# Install Docker (client part)
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    # Add the repository to Apt sources:
    && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y \
    # docker-ce \
    docker-ce-cli \
    # containerd.io \
    # docker-buildx-plugin \
    docker-compose-plugin

# Configuration des permissions correctes pour le dossier .ssh
RUN mkdir /workspaces && \
    chmod 707 /workspaces

USER ${USER}
ENV HOME=/home/${USER}

# Configuration des permissions correctes pour le dossier .ssh
RUN mkdir ${HOME}/.ssh && \
    chmod 700 ${HOME}/.ssh

COPY install-vscode-server.sh /usr/local/bin/install-vscode-server.sh
RUN sudo chmod +x /usr/local/bin/install-vscode-server.sh
# Installed at runtime from entrypoint so the /vscode volume is mounted

COPY install-vscode-remote-containers-server.sh /usr/local/bin/install-vscode-remote-containers-server.sh
COPY ensure-vscode-servers.sh /usr/local/bin/ensure-vscode-servers.sh
RUN sudo chmod +x /usr/local/bin/install-vscode-remote-containers-server.sh
RUN sudo chmod +x /usr/local/bin/ensure-vscode-servers.sh
# Installed at runtime from entrypoint so the /vscode volume is mounted

COPY entrypoint.sh /usr/local/bin/docker-ssh-entrypoint.sh
RUN sudo chmod +x /usr/local/bin/docker-ssh-entrypoint.sh
ENTRYPOINT [ "docker-ssh-entrypoint.sh" ]