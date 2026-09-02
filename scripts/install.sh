#!/usr/bin/env bash
# Olea Linux installer. Run from the live medium or the repository.

set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for module in helpers disk system boot provision swap mirror; do
    . "$dir/lib/$module.sh"
done

root_src="$dir"
if [[ ! -d $root_src/airootfs && ! -f $root_src/packages ]]; then
    root_src="$(dirname "$dir")/archiso"
fi
[[ -d $root_src/airootfs || -f $root_src/packages ]] || die 'cannot locate archiso assets'

declare -A preset
[[ -n ${OLEA_DISK:-} ]] && preset[disk]="$OLEA_DISK"
[[ -n ${OLEA_HOST:-} ]] && preset[host]="$OLEA_HOST"
[[ -n ${OLEA_USER:-} ]] && preset[user]="$OLEA_USER"
[[ -n ${OLEA_TZ:-} ]] && preset[tz]="$OLEA_TZ"
[[ -n ${OLEA_LOCALE:-} ]] && preset[locale]="$OLEA_LOCALE"
[[ -n ${OLEA_KEYMAP:-} ]] && preset[keymap]="$OLEA_KEYMAP"
[[ -n ${OLEA_ENCRYPT:-} ]] && preset[encrypt]="$OLEA_ENCRYPT"
[[ -n ${OLEA_PASS:-} ]] && preset[pass_root]="$OLEA_PASS"
[[ -n ${OLEA_PASS_USER:-} ]] && preset[pass_user]="$OLEA_PASS_USER"
[[ -n ${OLEA_SWAP:-} ]] && preset[swap]="$OLEA_SWAP"
[[ -n ${OLEA_YES:-} ]] && preset[yes]=yes

target=/mnt
disk=""
part_efi=""
part_root=""
root_dev=""
encrypt=no
hibernate=no
resume_args=""

main() {
    step 'Olea Linux installer'
    [[ $EUID -eq 0 ]] || die 'run as root'
    mountpoint -q "$target" && die "$target is already mounted"
    need pacstrap 'arch-install-scripts'
    need arch-chroot 'arch-install-scripts'
    need sgdisk 'gptfdisk'
    need mkfs.vfat 'dosfstools'
    need mkfs.ext4 'e2fsprogs'
    need genfstab 'arch-install-scripts'
    need bootctl 'systemd'
    need blkid 'util-linux'
    need findmnt 'util-linux'
    need lsblk 'util-linux'
    need mount 'util-linux'
    need cryptsetup 'cryptsetup'
    need filefrag 'e2fsprogs'

    pick_disk
    confirm "erase $disk and install Olea Linux?" || die 'aborted'
    partition_disk
    encrypt_root
    format_mount
    set_mirrors
    bootstrap
    init_swap
    write_init_fs
    write_fstab
    install_boot
    set_timezone
    set_locale
    set_hostname
    set_users
    enable_services
    set_configs

    step 'installation complete'
    printf '%s\n' "unmount with 'umount -R $target' then reboot"
}

main