#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SETTINGS_DIR="/home/dst/.klei/DoNotStarveTogether"
DST_STEAM_APP_ID="343050"
DST_INSTALL_DIR="/home/dst/steamapps/dst"
STEAMCMD_PATH="/usr/games/steamcmd"

if [[ "$(sudo ls "${SETTINGS_DIR}" | wc -l)" == "1" ]]; then
  cluster_name="$(sudo ls "${SETTINGS_DIR}")"
else
    echo "Select Cluster Name:"
    select cluster_name in $(sudo ls "${SETTINGS_DIR}"); do
    sudo test -n "${cluster_name}" && break;
    echo ">>> Invalid Selection"; 
    done
fi
echo "cluster_name=${cluster_name}"

[[ "$(systemctl list-units --all --quiet dst-${cluster_name}-Master.service dst-${cluster_name}-Caves.service | wc -l)" == "2" ]] || {
    echo "Failed to find services" >&2
    systemctl list-units --all dst-${cluster_name}-Master.service dst-${cluster_name}-Caves.service
    exit 1
}

! systemctl is-active --quiet "dst-${cluster_name}-Master.service" "dst-${cluster_name}-Caves.service" || {
  systemctl is-active "dst-${cluster_name}-Master.service" "dst-${cluster_name}-Caves.service"
  echo "One or more services already running" >&2
    exit 1
}

set -x

"${SCRIPT_DIR}/dst_update.sh"

sudo systemctl start "dst-${cluster_name}-Master.service" "dst-${cluster_name}-Caves.service"

# CLUSTER_ID="XXX_CLUSTER_NAME_XXX"

# "${SCRIPT_DIR}/dst_update.sh"

# cd "${DST_INSTALL_DIR}/bin64"

# "./dontstarve_dedicated_server_nullrenderer_x64" -cluster "${CLUSTER_ID}" -shard "Caves" &
# caves_pid=$!

# "./dontstarve_dedicated_server_nullrenderer_x64" -cluster "${CLUSTER_ID}" -shard "Master"

# wait "$caves_pid"
