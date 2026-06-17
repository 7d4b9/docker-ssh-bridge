#!/usr/bin/env bash

set -euo pipefail

trap "echo Exited entrypoint with code $?." EXIT
echo "Ensuring VSCode servers are installed"

export VSCODE_SERVER_COMMIT=${VSCODE_SERVER_COMMIT:-latest}

if [ "${VSCODE_SERVER_COMMIT}" = "latest" ]; then
  TAG=$(curl -s https://api.github.com/repos/microsoft/vscode/releases/latest \
    | jq -r .tag_name)
  VSCODE_SERVER_COMMIT=$(curl -s https://api.github.com/repos/microsoft/vscode/git/ref/tags/$TAG \
    | jq -r .object.sha)
fi

COMMIT="${VSCODE_SERVER_COMMIT:-}"

if [ -z "${COMMIT}" ]; then
  echo "Error: VSCODE_SERVER_COMMIT is not set."
  echo "Set it via environment or pass it through docker-compose / make."
  echo "Error: VSCODE_SERVER_COMMIT is not set."
  exit 1
fi

echo "Using VSCode commit ${COMMIT}"

docker-ssh-bridge-vscode-server-install.sh

docker-ssh-bridge-vscode-remote-containers-server-install.sh
