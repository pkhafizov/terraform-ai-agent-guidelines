#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="tests"

if [[ ! -d "$TEST_DIR" ]]; then
  echo "Error: The tests directory ('$TEST_DIR') was not found. Please ensure the directory exists and follows the expected structure." >&2
  exit 1
fi

go test "./${TEST_DIR}/..." "$@"
