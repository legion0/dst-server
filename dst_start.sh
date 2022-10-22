#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SETTINGS_DIR="/home/dst/.klei/DoNotStarveTogether"
DST_STEAM_APP_ID="343050"

cluster_name="$("${SCRIPT_DIR}/cluster_select.sh")"
echo "cluster_name=${cluster_name}"

[[ "$(systemctl list-units --all --quiet dst-${cluster_name}-Master.service dst-${cluster_name}-Caves.service | wc -l)" == "2" ]] || {
    echo "ERROR: Failed to find services" >&2
    systemctl list-units --all dst-${cluster_name}-Master.service dst-${cluster_name}-Caves.service
    exit 1
}

! systemctl is-active --quiet "dst-${cluster_name}-Master.service" "dst-${cluster_name}-Caves.service" || {
  echo "ERROR: One or more services already running" >&2
    exit 1
}

set -x
# TODO: make backup of modsettings before update since update overwrites modsettings
# "${SCRIPT_DIR}/dst_update.sh"

sudo systemctl start "dst-${cluster_name}-Master.service" "dst-${cluster_name}-Caves.service"
