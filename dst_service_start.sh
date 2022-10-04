#!/usr/bin/env bash

SETTINGS_DIR="/home/dst/.klei/DoNotStarveTogether"

clusters="$(sudo ls -d "${SETTINGS_DIR}")"
select cluster_name in "${SETTINGS_DIR}"/*;
do test -n "$cluster_name" && break; 
echo ">>> Invalid Selection"; 
done
echo "$cluster_name"

sudo systemctl start dont-starve-server.slice
