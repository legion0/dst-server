#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

[[ "${USER}" == "dst" ]] || {
    echo "WARNING: Not user dst, running with sudo"
    sudo cp "${SCRIPT_DIR}/dst_update.sh" "/home/dst/dst_update.sh"
    sudo chown dst:dst "/home/dst/dst_update.sh"
    sudo -u dst /bin/bash -c '~/dst_update.sh'
    exit $?
}

DST_STEAM_APP_ID=343050
DST_INSTALL_DIR="/home/dst/steamapps/dst"
STEAMCMD_PATH="/usr/games/steamcmd"

mkdir -p "${DST_INSTALL_DIR}"

"${STEAMCMD_PATH}" +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +force_install_dir "${DST_INSTALL_DIR}" +login anonymous +app_update "${DST_STEAM_APP_ID}" validate +quit

cd "${DST_INSTALL_DIR}/bin64"
