#!/usr/bin/env bash
# Build the Olea Linux ISO.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(dirname "$script_dir")"
profile_dir="$project_dir/archiso"
output_dir="$project_dir/out"
stage_dir="$output_dir/stage"

version() {
    if git -C "$project_dir" describe --tags --abbrev=0 2>/dev/null; then
        return
    fi
    if git -C "$project_dir" rev-parse --short HEAD 2>/dev/null; then
        return
    fi
    date +%Y.%m.%d
}

trap 'rm -rf "$stage_dir"' EXIT

if ! command -v mkarchiso &>/dev/null; then
    echo "mkarchiso not found. Install archiso: sudo pacman -S archiso" >&2
    exit 1
fi

mkdir -p "$output_dir"
rm -rf "$stage_dir"
sudo rm -rf "$output_dir/work"
cp -a "$profile_dir/." "$stage_dir"
printf '%s\n' "$(version)" > "$stage_dir/VERSION"
install -Dm755 "$project_dir/scripts/install.sh" "$stage_dir/airootfs/root/install.sh"
cp -a "$project_dir/scripts/lib" "$stage_dir/airootfs/root/lib"
install -Dm644 "$profile_dir/packages.x86_64" "$stage_dir/airootfs/root/packages"

echo "Building Olea Linux $(cat "$stage_dir/VERSION")..."
sudo mkarchiso -v -w "$output_dir/work" -o "$output_dir" "$stage_dir"

echo "Build complete."
ls -lh "$output_dir"/*.iso