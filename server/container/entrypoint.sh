#!/usr/bin/env bash

set -euo pipefail

docker-ssh-bridge-install.sh

exec "$@"
