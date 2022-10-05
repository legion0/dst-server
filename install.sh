#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

DST_STEAM_APP_ID="343050"
DST_INSTALL_DIR="/home/dst/steamapps/dst"
STEAMCMD_PATH="/usr/games/steamcmd"
SETTINGS_DIR="/home/steam/.klei/DoNotStarveTogether"
# dontstarve_dedicated_server_nullrenderer_x64

sudo apt-get update && sudo apt-get upgrade -y
sudo apt install -y tmux git
sudo dpkg --add-architecture i386
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install -y software-properties-common
sudo add-apt-repository -y multiverse
sudo apt install -y steamcmd lib32stdc++6 libc6-i386 libcurl4-gnutls-dev:i386 lib32gcc-s1 libsdl2-2.0-0:i386

echo "Creating the dst user"

sudo useradd -ms /bin/bash dst

echo "Copying install files"

sudo cp "${SCRIPT_DIR}/dst_update.sh" "/home/dst/dst_update.sh"
sudo chown dst:dst "/home/dst/dst_update.sh"

sudo cp "${SCRIPT_DIR}/dst_start.sh" "/home/dst/dst_start.sh"
sudo chown dst:dst "/home/dst/dst_start.sh"

# echo "Starting sudo shell to instal game as the dst user, please run:"
# echo '~/dst_update.sh; exit $?'
# sudo -u dst -s

echo "Starting sudo shell to instal game as the dst user"
sudo -u dst /bin/bash -c '~/dst_update.sh'


echo ""
echo "# Creating Game Server Configuration"
echo ""

"${SCRIPT_DIR}/add_cluster.sh"
