#!/usr/bin/env bash

set -euo pipefail

mkdir -p /var/run/sshd

echo Generating server HostKeys for sshd
ssh-keygen -A

echo Setting correct permission for directory /etc/ssh/
sudo chmod -R 755 /etc/ssh/

echo granting access to ${SSH_PUBLIC_KEY}
cat ${SSH_PUBLIC_KEY}

docker-ssh-bridge-ensure-vscode-servers.sh

