#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SETTINGS_DIR="/home/dst/.klei/DoNotStarveTogether"

[[ "${USER}" == "dst" ]] || {
    echo "WARNING: Not user dst, running with sudo"
    sudo cp "${BASH_SOURCE[0]}" "/home/dst/cluster_select.sh"
    sudo chown dst:dst "/home/dst/cluster_select.sh"
    sudo -u dst /bin/bash -c '~/cluster_select.sh'
    exit $?
}

function cluster_select() {
  PYTHONUNBUFFERED=1 python3 -u <(cat <<EOF
clusters_directory='${SETTINGS_DIR}'
import os, sys
clusters = [x for x in os.listdir(clusters_directory) if os.path.isdir(x) and os.path.exists(os.path.join(x, 'cluster.ini'))]
# clusters = [x for x in os.listdir(clusters_directory) if os.path.isdir(x)]
if len(clusters) == 0:
  sys.stderr.write('No clusters found in {}\n'.format(clusters_directory))
  sys.exit(1)
if len(clusters) == 1:
  print(clusters[0])
  sys.exit(0)
input_message = 'Please select a cluster:\n'
for index, item in enumerate(clusters):
  input_message += f'{index+1}) {item}\n'
input_message += 'Select Cluster: '
user_input = ''
while user_input not in map(str, range(1, len(clusters) + 1)):
  sys.stderr.write(input_message)
  user_input = input('')
print(clusters[int(user_input) - 1])
EOF
  )
  return $?
}

cluster="$(cluster_select)" || exit $?
echo "${cluster}"
