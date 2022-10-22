#!/usr/bin/env bash

set -euo pipefail

SETTINGS_DIR="/home/dst/.klei/DoNotStarveTogether"

function select_cluster_f() {
  local nullglob_reset
  shopt -q nullglob && nullglob_reset="-s" || nullglob_reset="-u"
  shopt -q dotglob && dotglob_reset="-s" || dotglob_reset="-u"

  declare -a directories
  directories=("${SETTINGS_DIR}/"*/)

  if [[ "${#directories[@]}" == 1 ]]; then
    echo "${directories[@]}"
  else
    echo "Select Cluster Name:"
    select cluster_name in "${directories[@]}"; do
      sudo test -n "${cluster_name}" && break;
      echo ">>> Invalid Selection"; 
    done
    echo "${cluster_name}"
  fi

  shopt "${nullglob_reset}" nullglob
  shopt "${dotglob_reset}" nullglob
}

echo "$(select_cluster_f)"
