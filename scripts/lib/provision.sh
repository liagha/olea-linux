#!/usr/bin/env bash
# Copy Olea configs into the installed system.

set_configs() {
    step 'install olea configs'
    local skel="$root_src/airootfs/etc/skel"
    [[ -d $skel ]] || skel='/etc/skel'
    local wall="$root_src/airootfs/usr/share/wallpapers"
    [[ -d $wall ]] || wall='/usr/share/wallpapers'
    cp -a "$skel/." "$target/etc/skel/"
    mkdir -p "$target/usr/share/wallpapers"
    cp -a "$wall/." "$target/usr/share/wallpapers/"
}