#!/usr/bin/env bash

set -euo pipefail

: "${VSCODE_SERVER_COMMIT:?VSCODE_SERVER_COMMIT not set}"
ARCH="${VSCODE_SERVER_ARCH:-linux-x64}"

COMMIT="${VSCODE_SERVER_COMMIT}"

SERVER_BASE="${HOME}/.vscode-server/cli/servers/Stable-${COMMIT}"
TMP_TGZ="/tmp/vscode-server.tar.gz"

echo "[*] Installing VS Code Remote‑SSH server for commit ${COMMIT}"
echo "[*] Target directory: ${SERVER_BASE}"

curl -fsSL \
  "https://update.code.visualstudio.com/commit:${COMMIT}/server-${ARCH}/stable" \
  -o "${TMP_TGZ}"

if [ -x "${SERVER_BASE}/server/bin/remote-cli/node" ]; then
  echo "[*] Remote‑SSH server already installed at ${SERVER_BASE}"
else
  echo "[*] Extracting server into ${SERVER_BASE}"
  mkdir -p "${SERVER_BASE}"
  tar -xzf "${TMP_TGZ}" -C "${SERVER_BASE}" --strip-components=0
fi

echo "[✓] Remote‑SSH VS Code Server installation complete."