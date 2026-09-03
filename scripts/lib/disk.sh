#!/usr/bin/env bash
# Disk selection, partitioning, encryption, formatting and mounting.

pick_disk() {
    step 'select disk'
    lsblk -ndp -e 7,253 -o NAME,SIZE,MODEL
    local hint
    hint="$(lsblk -ndp -e 7,253 -bo NAME,SIZE | awk '$2+0>max{max=$2+0;dev=$1} END{print dev}')"
    disk="$(ask 'install to (whole disk)' "$hint")"
    [[ $disk == /* ]] || disk="/dev/$disk"
    [[ -b $disk ]] || die "not a block device: $disk"
    mountpoint -q "$disk" && die "block device in use: $disk"
}

partition_disk() {
    step 'partition disk'
    local p1 p2
    if [[ $disk =~ [0-9]$ ]]; then
        p1="${disk}p1"
        p2="${disk}p2"
    else
        p1="${disk}1"
        p2="${disk}2"
    fi
    sgdisk --zap-all "$disk"
    sgdisk --new=1:0:+512M --typecode=1:ef00 --new=2:0:0 --typecode=2:8300 "$disk"
    sleep 1
    part_efi="$p1"
    part_root="$p2"
    lsblk "$disk"
}

encrypt_root() {
    step 'encrypt root'
    encrypt=no
    root_dev="$part_root"
    confirm 'encrypt root with LUKS?' || return 0
    local key="$(mktemp)"
    pass 'encryption passphrase' luks > "$key"
    cryptsetup luksFormat --type luks2 --key-file "$key" --batch-mode "$part_root"
    cryptsetup open --key-file "$key" "$part_root" cryptroot
    rm -f "$key"
    encrypt=yes
    root_dev=/dev/mapper/cryptroot
}

format_mount() {
    step 'format and mount'
    mkfs.vfat -F32 "$part_efi"
    mkfs.ext4 -F "$root_dev"
    mkdir -p "$target"
    mount "$root_dev" "$target"
    mkdir -p "$target/boot"
    mount "$part_efi" "$target/boot"
}