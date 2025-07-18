#!/usr/bin/env bash
set -euo pipefail


dir="${dir:-${1:-}}"
if [[ -z "$dir" ]]; then
  echo "Usage: make docs dir=<path> OR ./docs.sh <path>" >&2
  exit 1
fi

if [[ ! -d "$dir" ]]; then
  echo "Directory $dir does not exist" >&2
  exit 1
fi

if ! ls "$dir"/*.tf >/dev/null 2>&1; then
  echo "No Terraform files found in $dir" >&2
  exit 0
fi

echo "Generating documentation for $dir"
if [[ -f "$dir/README.md" ]]; then
  echo "README.md already exists in $dir."
  read -p "Do you want to overwrite it? (y/N): " confirm
  if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborting. Documentation generation canceled."
    exit 0
  fi
  # Optionally create a backup
  cp "$dir/README.md" "$dir/README.md.bak"
  echo "Backup created: $dir/README.md.bak"
fi
if ! terraform-docs markdown "$dir" > "$dir/README.md"; then
  echo "Error: Failed to generate documentation using terraform-docs for $dir" >&2
  exit 1
fi
