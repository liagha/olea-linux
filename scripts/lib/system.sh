#!/usr/bin/env bash
# Base system bootstrap and system configuration.

bootstrap() {
    step 'install base system'
    printf '\n  downloading and installing packages (this may take a few minutes)...\n\n'
    local live_only=('mkinitcpio-archiso' 'arch-install-scripts' 'gptfdisk' 'dosfstools')
    [[ $encrypt == no ]] && live_only+=('cryptsetup')
    local list=() keep=() p
    mapfile -t list < <(sed '/^[[:blank:]]*#.*/d;s/#.*//;/^[[:blank:]]*$/d' "$root_src/packages")
    for p in "${list[@]}"; do
        case " ${live_only[*]} " in
            *" $p "*) continue ;;
        esac
        keep+=("$p")
    done
    pacstrap -K "$target" "${keep[@]}"
    cp /etc/pacman.d/mirrorlist "$target/etc/pacman.d/mirrorlist"
}

write_fstab() {
    step 'generate fstab'
    local fstab="$target/etc/fstab"
    touch "$fstab"
    genfstab -U "$target" >> "$fstab"
    [[ $hibernate == yes ]] && printf '%s\n' '/swapfile none swap defaults 0 0' >> "$fstab"
    [[ -s $fstab ]] || die 'fstab is empty'
}

write_init_fs() {
    [[ $encrypt == yes || $hibernate == yes ]] || return 0
    step 'configure initramfs'
    local hooks=('base' 'systemd' 'autodetect' 'modconf' 'kms' 'keyboard' 'keymap' 'consolefont' 'block' 'filesystems')
    [[ $encrypt == yes ]] && hooks+=('sd-encrypt')
    [[ $hibernate == yes ]] && hooks+=('sd-resume')
    printf 'HOOKS=(%s)\n' "${hooks[*]}" > "$target/etc/mkinitcpio.conf"
    in_chroot mkinitcpio -P
}

set_timezone() {
    step 'timezone'
    local host_tz="$(readlink -f /etc/localtime 2>/dev/null || true)"
    host_tz="${host_tz#/usr/share/zoneinfo/}"
    [[ -n $host_tz && -e /usr/share/zoneinfo/$host_tz ]] || host_tz='Asia/Tehran'
    local tz="$(ask 'timezone (Region/City)' "$host_tz")"
    [[ -e /usr/share/zoneinfo/$tz ]] || die "unknown timezone: $tz"
    ln -sf "/usr/share/zoneinfo/$tz" "$target/etc/localtime"
    in_chroot hwclock --systohc
}

set_locale() {
    step 'locale and keymap'
    local loc="$(ask 'locale' 'en_US.UTF-8')"
    grep -Eq "^#?$loc " "$target/etc/locale.gen" || die "unknown locale: $loc"
    sed -i "s/^#$loc/$loc/" "$target/etc/locale.gen"
    in_chroot locale-gen
    printf 'LANG=%s\n' "$loc" > "$target/etc/locale.conf"
    local km="$(ask 'keymap' 'us')"
    printf 'KEYMAP=%s\n' "$km" > "$target/etc/vconsole.conf"
}

set_hostname() {
    step 'hostname'
    local host="$(ask 'hostname' 'olea')"
    [[ $host =~ ^[A-Za-z0-9][A-Za-z0-9-]{0,62}$ ]] || die "invalid hostname: $host"
    printf '%s\n' "$host" > "$target/etc/hostname"
}

set_users() {
    step 'users'
    local root="$(pass 'root password' pass_root)"
    local user="$(ask 'user' 'olea')"
    [[ $user =~ ^[a-z_][a-z0-9_-]*$ ]] || die "invalid user: $user"
    local pass="$(pass "password for $user" pass_user)"
    printf '%s\n' "root:$root" "$user:$pass" | in_chroot chpasswd
    in_chroot useradd -m -G wheel -s /usr/bin/zsh "$user"
    in_chroot usermod --shell /usr/bin/zsh root
    printf '%s\n' '%wheel ALL=(ALL:ALL) ALL' > "$target/etc/sudoers.d/olea"
    chmod 440 "$target/etc/sudoers.d/olea"
}

enable_services() {
    step 'enable services'
    in_chroot systemctl enable NetworkManager systemd-timesyncd
    in_chroot systemctl --global enable pipewire pipewire-pulse wireplumber
}