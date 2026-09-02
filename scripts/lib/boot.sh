#!/usr/bin/env bash
# systemd-boot installation and boot entries.

install_boot() {
    step 'install bootloader'
    bootctl --root="$target" install
    local opts
    if [[ $encrypt == yes ]]; then
        opts="rd.luks.name=$(blkid -s UUID -o value "$part_root")=cryptroot root=/dev/mapper/cryptroot"
    else
        opts="root=PARTUUID=$(blkid -s PARTUUID -o value "$part_root")"
    fi
    [[ -n $resume_args ]] && opts+=" $resume_args"
    local loader="$target/boot/loader"
    mkdir -p "$loader/entries"
    printf '%s\n' 'timeout 3' 'console-mode max' 'default olea.conf' > "$loader/loader.conf"
    {
        printf 'title   Olea Linux\n'
        printf 'linux   /vmlinuz-linux\n'
        printf 'initrd  /initramfs-linux.img\n'
        printf 'options %s rw quiet\n' "$opts"
    } > "$loader/entries/olea.conf"
}