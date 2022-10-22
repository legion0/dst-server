#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cluster_name="$("${SCRIPT_DIR}/cluster_select.sh")"
echo "cluster_name=${cluster_name}"

sudo systemctl disable "dst-${cluster_name}-Master" "dst-${cluster_name}-Caves"
