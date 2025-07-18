#!/usr/bin/env bash
set -euo pipefail

dir="${dir:-${1:-}}"
if [[ -z "$dir" ]]; then
  echo "Usage: make infracost dir=<path> OR ./infracost.sh <path>" >&2
  exit 1
fi

if [[ ! -d "$dir" ]]; then
  echo "Directory $dir does not exist" >&2
  exit 1
fi

if ! find "$dir" -maxdepth 1 -name "*.tf" -type f >/dev/null 2>&1; then
  echo "No Terraform files found in $dir" >&2
  exit 0
fi

echo "Running Infracost for $dir"

infracost breakdown --path "$dir"
