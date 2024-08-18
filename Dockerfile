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

# Ajout des informations d'identification SSH pour le nouvel utilisateur (remplacez id_rsa.pub par votre clé publique)
RUN mkdir -p ${HOME}/.ssh/authorized_keys

# Configuration des permissions correctes pour le dossier .ssh
RUN sudo chown -R ${USER}:${USER} ${HOME}/.ssh && sleep 10 && \
chmod 700 ${HOME}/.ssh && \
chmod 600 ${HOME}/.ssh/*

RUN mkdir -p /var/run/sshd && \
    # Générer des clés d'hôte pour sshd
    ssh-keygen -A && \
    # Setting correct permission for directory
    sudo chmod -R 755 /etc/ssh/ && \
    # Setting correct permission for private keys
    sudo chmod 604 /etc/ssh/ssh_host_*_key && \
    # Setting correct permission for public keys
    sudo chmod 644 /etc/ssh/ssh_host_*_key.pub
    
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
