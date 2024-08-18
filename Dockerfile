FROM debian:bookworm

# Mise à jour du système et installation sudo, openssh-client, openssh-server, netcat
RUN apt-get update && \
    apt-get install -y \
    sudo \
    openssh-client \
    openssh-server \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Configuration du server SSH
RUN mkdir /var/run/sshd

ENV USER=devuser

# Création d'un nouvel utilisateur sans mot de passe
RUN useradd -m ${USER} && echo "${USER}:${USER}" | chpasswd && adduser ${USER} sudo \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devuser \
    && chmod 0440 /etc/sudoers.d/devuser
USER ${USER}
ENV HOME=/home/${USER}

# Configuration des permissions correctes pour le dossier .ssh
RUN mkdir ${HOME}/.ssh && \
    chmod 700 ${HOME}/.ssh

