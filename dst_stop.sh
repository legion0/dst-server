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

[[ "$(systemctl list-units --all --quiet dst-${cluster_name}-Master.service dst-${cluster_name}-Caves.service | wc -l)" == "2" ]] || {
    echo "Failed to find services" >&2
    exit 1
}

"${SCRIPT_DIR}/dst_update.sh"

sudo systemctl stop "dst-${cluster_name}-Master.service" "dst-${cluster_name}-Caves.service"

# CLUSTER_ID="XXX_CLUSTER_NAME_XXX"

# "${SCRIPT_DIR}/dst_update.sh"

# cd "${DST_INSTALL_DIR}/bin64"

# "./dontstarve_dedicated_server_nullrenderer_x64" -cluster "${CLUSTER_ID}" -shard "Caves" &
# caves_pid=$!

# "./dontstarve_dedicated_server_nullrenderer_x64" -cluster "${CLUSTER_ID}" -shard "Master"

# wait "$caves_pid"
