#!/usr/bin/env bash
set -euo pipefail

if [[ ! -x "$0" ]]; then
  echo "Error: Script does not have execution permissions. Please run 'chmod +x $0' and try again." >&2
  exit 1
fi
CONFIG_FILE=".tflint.hcl"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Missing $CONFIG_FILE" >&2
  exit 1
fi

tflint --init --config "$CONFIG_FILE"

tflint --config "$CONFIG_FILE" "$@"
