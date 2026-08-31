#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(dirname "$script_dir")"
profile_dir="$project_dir/archiso"
output_dir="$project_dir/out"

mkdir -p "$output_dir"

if ! command -v mkarchiso &>/dev/null; then
    echo "mkarchiso not found. Install archiso: sudo pacman -S archiso"
    exit 1
fi

echo "Building Olea Linux ISO..."

sudo mkarchiso -v -w "$output_dir/work" -o "$output_dir" "$profile_dir"

echo "Build complete. ISO in $output_dir/"
ls -lh "$output_dir"/*.iso 2>/dev/null || echo "No ISO found"
