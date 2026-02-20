#!/usr/bin/env bash
set -euo pipefail

: "${VSCODE_SERVER_COMMIT:?VSCODE_SERVER_COMMIT not set}"
ARCH="${VSCODE_SERVER_ARCH:-linux-x64}"

COMMIT="${VSCODE_SERVER_COMMIT}"

# ---------------------------
# PATHS
# ---------------------------

# Host path used by DevContainers over SSH
HOST_BASE="${HOME}/.vscode-remote-containers/bin/${COMMIT}"

# Volume path used inside the docker-ssh-bridge container
VOLUME_BASE="/vscode/vscode-server/bin/${ARCH}/${COMMIT}"

# ---------------------------
# DOWNLOAD
# ---------------------------

TMP_TGZ="/tmp/vscode-server.tar.gz"

echo "[*] Downloading VSCode server for commit ${COMMIT}"
curl -fsSL \
  "https://update.code.visualstudio.com/commit:${COMMIT}/server-${ARCH}/stable" \
  -o "${TMP_TGZ}"

# ---------------------------
# INSTALL INTO HOST_BASE
# ---------------------------

if [ -x "${HOST_BASE}/node" ]; then
  echo "[*] Host VSCode Server already installed at ${HOST_BASE}"
else
  echo "[*] Installing VSCode Server into host path: ${HOST_BASE}"
  mkdir -p "${HOST_BASE}"
  tar -xzf "${TMP_TGZ}" -C "${HOST_BASE}" --strip-components=1
fi

# ---------------------------
# INSTALL INTO VOLUME_BASE
# ---------------------------

if [ -x "${VOLUME_BASE}/node" ]; then
  echo "[*] Volume VSCode Server already installed at ${VOLUME_BASE}"
else
  echo "[*] Installing VSCode Server into volume path: ${VOLUME_BASE}"
  sudo mkdir -p "${VOLUME_BASE}"
  sudo tar -xzf "${TMP_TGZ}" -C "${VOLUME_BASE}" --strip-components=1
  sudo chmod -R 755 "${VOLUME_BASE}"
fi

echo "[✓] VSCode Server installation done for ${COMMIT}"