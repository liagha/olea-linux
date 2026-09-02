#!/usr/bin/env bash
# Swap (zram) and hibernation setup.

init_swap() {
    step 'swap'
    if confirm 'enable zram swap?'; then
        mkdir -p "$target/etc/systemd"
        cat > "$target/etc/systemd/zram-generator.conf" <<'EOF'
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF
    fi
    hibernate=no
    confirm 'enable hibernation? (reserve a swapfile on disk)' || return 0
    step 'hibernation swapfile'
    local ram="$(awk '/MemTotal/{printf "%d", $2/1024}' /proc/meminfo)"
    local size="$(ask 'swapfile size in MiB' "$ram")"
    [[ $size =~ ^[0-9]+$ ]] || die "invalid swapfile size: $size"
    truncate -s "${size}M" "$target/swapfile"
    chmod 600 "$target/swapfile"
    mkswap "$target/swapfile"
    local offset="$(filefrag -v "$target/swapfile" | awk 'NR==4{gsub(/.*[: ]/,"");print $1}')"
    [[ -n $offset ]] || die 'cannot determine swapfile offset'
    resume_args="resume=UUID=$(blkid -s UUID -o value "$root_dev") resume_offset=$offset"
    hibernate=yes
}