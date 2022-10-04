#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

DST_STEAM_APP_ID="343050"
DST_INSTALL_DIR="/home/dst/steamapps/dst"
STEAMCMD_PATH="/usr/games/steamcmd"

CLUSTER_ID="XXX_CLUSTER_NAME_XXX"

"${SCRIPT_DIR}/dst_update.sh"

cd "${DST_INSTALL_DIR}/bin64"

"./dontstarve_dedicated_server_nullrenderer_x64" -cluster "${CLUSTER_ID}" -shard "Caves" &
caves_pid=$!

"./dontstarve_dedicated_server_nullrenderer_x64" -cluster "${CLUSTER_ID}" -shard "Master"

wait "$caves_pid"
