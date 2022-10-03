#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo  "Not Implemented !!!"
exit 1

DST_STEAM_APP_ID=343050

dpkg --add-architecture i386
apt-get update && apt-get upgrade -y
sudo apt install software-properties-common
sudo add-apt-repository multiverse

sudo apt install tmux git lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386 lib32gcc-s1 steamcmd

SETTINGS_DIR=/home/steam/.klei/DoNotStarveTogether/MidWeekDST
GAME_INSTALL_DIR=/home/steam/steamapps/dst
SERVER_MODS_DIR="${GAME_INSTALL_DIR}/mods"
GAME_BIN_PATH="${GAME_INSTALL_DIR}/bin64/dontstarve_dedicated_server_nullrenderer_x64"

useradd -ms /bin/bash/ dst

XXX_CLUSTER_NAME_XXX
XXX_CLUSTER_PASSWORD_XXX
XXX_CLUSTER_KEY_XXX

echo "# Creating Cluster"

echo -n "Cluster Name: (default: Cluster_1)"
read cluster_name
cluster_name="${cluster_name:=Cluster_1}"
echo "Cluster Name = ${cluster_name}"

echo -n "Cluster Password: (default: none)"
read cluster_password
echo "Cluster Password = ${cluster_password}"

cluster_key="$(openssl rand -hex 16)"

echo "# Linking systemd/dont-starve-server@.service"
ln -s  "${SCRIPT_DIR}systemd/dont-starve-server@.service" "/etc/systemd/system/dont-starve-server@.service"
