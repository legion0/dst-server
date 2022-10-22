#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cluster_name="$("${SCRIPT_DIR}/cluster_select.sh")"
echo "cluster_name=${cluster_name}"

[[ "$(systemctl list-units --all --quiet dst-${cluster_name}-Master.service dst-${cluster_name}-Caves.service | wc -l)" == "2" ]] || {
    echo "ERROR: Failed to find services" >&2
    systemctl list-units --all dst-${cluster_name}-Master.service dst-${cluster_name}-Caves.service
    exit 1
}

sudo systemctl stop "dst-${cluster_name}-Master.service" "dst-${cluster_name}-Caves.service"
