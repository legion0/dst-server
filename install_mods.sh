#!/usr/bin/env bash
set -euo pipefail

DST_INSTALL_DIR="/home/dst/steamapps/dst"
SETTINGS_DIR="/home/dst/.klei/DoNotStarveTogether"

echo "Select Cluster Name:"
select cluster_name in $(sudo ls "${SETTINGS_DIR}");
do sudo test -n "$cluster_name" && break;
echo ">>> Invalid Selection"; 
done
# echo "cluster_name=$cluster_name"

install_more_mods="y"
while [[ "${install_more_mods}" == "y" ]]; do
    echo -n "Mod id: "
    read mod_id
    echo -n "Mod name: "
    read mod_name
    # TODO: check if mod is already installed

    echo "Enabling mod"
    echo "ServerModSetup(\"${mod_id}\") -- ${mod_name}" | sudo tee -a "${DST_INSTALL_DIR}/mods/dedicated_server_mods_setup.lua" >/dev/null
    sudo chown -R dst:dst "${DST_INSTALL_DIR}/mods"

    echo "Enabling mod override for ${cluster_name}"
    sudo sed -i -e "s/    -- XXX_ADD_MODS_HERE_XXX/    \[\"workshop-${mod_id}\"\]={ enabled=true },  -- ${mod_name}\n    -- XXX_ADD_MODS_HERE_XXX/g" "${SETTINGS_DIR}/${cluster_name}/Master/modoverrides.lua"
    sudo cp -f "${SETTINGS_DIR}/${cluster_name}/Master/modoverrides.lua" "${SETTINGS_DIR}/${cluster_name}/Caves/modoverrides.lua"
    sudo chown -R dst:dst "${SETTINGS_DIR}/${cluster_name}"

    echo -n "Install additional mods? (y/n): "
    read install_more_mods
done
