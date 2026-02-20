#!/usr/bin/env bash

set -euo pipefail

# List to hold background job PIDs
bg_pids=()

cleanup() {
    for pid in "${bg_pids[@]}"; do
        kill "$pid"
        wait "$pid" 2>/dev/null
    done
}

trap "echo Exited entrypoint with code $?." EXIT

mkdir -p /var/run/sshd

echo Generating server HostKeys for sshd
ssh-keygen -A

echo Setting correct permission for directory /etc/ssh/
sudo chmod -R 755 /etc/ssh/

echo Starting sshd.
sudo sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
/usr/sbin/sshd -D &
bg_pids+=($!)
until nc -z localhost 22 ; do
echo waiting sshd...
sleep 1
done
echo sshd started: listening at localhost:22

echo granting access to ${SSH_PUBLIC_KEY}
cat ${SSH_PUBLIC_KEY}

sudo chmod o+rw /var/run/docker.sock

if [ $# -eq 0 ]; then
  echo "[entrypoint] No command passed, entering sleep infinity to keep container alive"
  wait ${bg_pids[@]}
else
  exec "$@"
fi