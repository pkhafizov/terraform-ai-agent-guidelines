#!/usr/bin/env bash
set -euo pipefail

dir="${dir:-${1:-}}"
if [[ -z "$dir" ]]; then
  echo "Usage: make validate dir=<path> OR ./validate.sh <path>" >&2
  exit 1
fi

if terraform -chdir="$dir" validate; then
  echo "Terraform validation succeeded for directory: $dir"
else
  echo "Terraform validation failed for directory: $dir" >&2
  exit 1
fi
