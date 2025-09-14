#!/usr/bin/env bash
set -euo pipefail
# Requires lychee installed locally: cargo install lychee
lychee --config .github/lychee.toml --no-progress --verbose .
