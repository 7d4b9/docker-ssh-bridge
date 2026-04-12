#!/usr/bin/env bash

set -euo pipefail

trap "echo Exited entrypoint with code $?." EXIT
echo "Ensuring VSCode servers are installed"

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

/usr/local/bin/install-vscode-server.sh
/usr/local/bin/install-vscode-remote-containers-server.sh
