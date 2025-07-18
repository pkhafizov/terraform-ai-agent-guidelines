#!/usr/bin/env bash
set -euo pipefail

dir="${dir:-${1:-}}"
if [[ -z "$dir" ]]; then
  echo "Usage: make init dir=<path>" >&2
  exit 1
fi

terraform -chdir="$dir" init
