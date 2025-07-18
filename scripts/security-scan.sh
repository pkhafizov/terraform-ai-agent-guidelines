#!/usr/bin/env bash
set -euo pipefail

DIR="${DIR:-${1:-.}}"

echo "Running tfsec on $DIR"
tfsec "$DIR"

echo "Running checkov on $DIR"
checkov -d "$DIR"
