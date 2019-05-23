#!/bin/bash
set -euo pipefail
if [[ "$1" == "--help" ]]; then
  echo "[version 1.6]"
  exit 0
fi
exec java -jar /opt/jqplay/jackson-jq-cli.jar "$@"
