#!/usr/bin/env bash
set -euo pipefail

# Extract version from config.h, e.g. "1.6.8" -> "168"
VERSION=$(grep -oE '"[0-9]+\.[0-9]+\.[0-9]+"' config.h | tr -d '".')

echo "Building firmware version $VERSION"

# Clean rebuild of all environments
#pio run --target clean
#pio run

mkdir -p release-fw

copy_env() {
  local env=$1 name=$2
  local src=".pio/build/${env}/firmware.hex"
  local dst="release-fw/${name}-v${VERSION}.hex"
  if [[ -f "$src" ]]; then
    cp "$src" "$dst"
    echo "  $dst"
  else
    echo "  WARNING: $src not found, skipping"
  fi
}

copy_env nuevi         NuEVI-R1
copy_env nuevi_teensy40 NuEVI-R2
copy_env nurad         NuRAD-R1
copy_env nurad_teensy40 NuRAD-R2

echo "Done."
