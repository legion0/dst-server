#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# DST_STEAM_APP_ID="343050"
# DST_INSTALL_DIR="/home/dst/steamapps/dst"
# STEAMCMD_PATH="/usr/games/steamcmd"
SETTINGS_DIR="/home/dst/.klei/DoNotStarveTogether"

echo -n "Game Server Name: (default: ${USER} DST Server)"
read server_name
server_name="${cluster_name:="${USER} DST Server"}"
echo "Game Server Name = ${server_name}"

cluster_name_def="$(echo "${server_name}" | tr --complement --delete '[:alnum:]')"

echo -n "Cluster Name: (default: ${cluster_name_def})"
read cluster_name
cluster_name="${cluster_name:="${cluster_name_def}"}"
echo "Cluster Name = ${cluster_name}"

if ! echo "${cluster_name}" | grep --extended-regexp --quiet '^[a-zA-Z]'; then
    echo "ERROR: Invalid Cluster Name!"
    exit 1
fi

echo -n "Game Server Password: (default: SuperSecretPassword)"
read server_password
server_password="${server_password:="SuperSecretPassword"}"
echo "Game Server Password = ${server_password}"

cluster_key="$(openssl rand -hex 16)"
echo "Cluster Key = ${cluster_key}"

echo "Please get a Server Token from https://accounts.klei.com/account/game/servers?game=DontStarveTogether:"
read cluster_token
echo "Server Token = ${cluster_token}"

echo "# Copying cluster files"
sudo cp -r "${SCRIPT_DIR}/cluster_config" "${SETTINGS_DIR}/${cluster_name}"

echo "Updating cluster token"
echo "${cluster_token}" | sudo tee "${SETTINGS_DIR}/${cluster_name}/cluster_token.txt" >/dev/null

echo "Updating cluster.ini config"
sudo sed -i -e "s/XXX_SERVER_NAME_XXX/${server_name}/g" \
  -e "s/XXX_SERVER_PASSWORD_XXX/${server_password}/g" \
  -e "s/XXX_CLUSTER_KEY_XXX/${cluster_key}/g" \
  "${SETTINGS_DIR}/${cluster_name}/cluster.ini"

sudo chown -R dst:dst "${SETTINGS_DIR}/${cluster_name}"

# TODO: Install mod overrides and server mod if needed.

echo "# Registering with systemd"
echo ""
echo -n "Would you like to start this cluster when the machine boots? (y/n): "
read answer
if [[ "${answer}" == "y" ]]; then

  echo "Creating /etc/systemd/system/dst-${cluster_name}-Master.service"
  sed -e "s/XXX_CLUSTER_NAME_XXX/${cluster_name}/g" -e "s/XXX_SHARD_XXX/Master/g" "${SCRIPT_DIR}/systemd/dst.service" | sudo tee "/etc/systemd/system/dst-${cluster_name}-Master.service" >/dev/null
  echo "Creating /etc/systemd/system/dst-${cluster_name}-Caves.service"
  sed -e "s/XXX_CLUSTER_NAME_XXX/${cluster_name}/g" -e "s/XXX_SHARD_XXX/Caves/g" "${SCRIPT_DIR}/systemd/dst.service" | sudo tee "/etc/systemd/system/dst-${cluster_name}-Caves.service" >/dev/null
  echo "Enabling services on startup"
  sudo systemctl enable dst-${cluster_name}-Master.service dst-${cluster_name}-Caves.service
  sudo systemctl start "dst-${cluster_name}.slice"
fi
