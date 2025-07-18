#!/usr/bin/env bash
set -euo pipefail

terraform fmt -recursive -check
