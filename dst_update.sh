#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

[[ "${USER}" == "dst" ]] || {
    echo "WARNING: Not user dst, running with sudo"
    sudo cp "${BASH_SOURCE[0]}" "/home/dst/dst_update.sh"
    sudo chown dst:dst "/home/dst/dst_update.sh"
    sudo -u dst /bin/bash -c '~/dst_update.sh'
    exit $?
}

DST_STEAM_APP_ID=343050
DST_INSTALL_DIR="/home/dst/steamapps/dst"
STEAMCMD_PATH="/usr/games/steamcmd"

mkdir -p "${DST_INSTALL_DIR}"

mods_backup=''
if [[ -e "${DST_INSTALL_DIR}/mods/dedicated_server_mods_setup.lua" ]]; then
  mods_backup="$(mktemp)"
  echo "Copying ${DST_INSTALL_DIR}/mods/dedicated_server_mods_setup.lua to a temporary backup at ${mods_backup}"
  cp -f "${DST_INSTALL_DIR}/mods/dedicated_server_mods_setup.lua" "${mods_backup}"
fi

"${STEAMCMD_PATH}" +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +force_install_dir "${DST_INSTALL_DIR}" +login anonymous +app_update "${DST_STEAM_APP_ID}" validate +quit

if [[ -n "${mods_backup}" ]]; then
  echo "Restoring ${DST_INSTALL_DIR}/mods/dedicated_server_mods_setup.lua from temporary backup at ${mods_backup}"
  cp -f "${mods_backup}" "${DST_INSTALL_DIR}/mods/dedicated_server_mods_setup.lua"
  echo "Deleting temporary backup at ${mods_backup}"
  rm -f "${mods_backup}"
fi
