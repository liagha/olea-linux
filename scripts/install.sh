#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(dirname "$script_dir")"

configure_sway() {
    mkdir -p ~/.config/sway
    cp -r "$project_dir/archiso/airootfs/etc/skel/.config/sway/"* ~/.config/sway/
}

configure_waybar() {
    mkdir -p ~/.config/waybar
    cp -r "$project_dir/archiso/airootfs/etc/skel/.config/waybar/"* ~/.config/waybar/
}

configure_foot() {
    mkdir -p ~/.config/foot
    cp -r "$project_dir/archiso/airootfs/etc/skel/.config/foot/"* ~/.config/foot/
}

configure_shell() {
    if ! grep -q "/bin/zsh" /etc/shells; then
        echo "/bin/zsh" | sudo tee -a /etc/shells >/dev/null
    fi
    chsh -s /bin/zsh
}

enable_services() {
    sudo systemctl enable NetworkManager
    sudo systemctl enable pipewire
    sudo systemctl enable pipewire-pulse
}

main() {
    echo "Configuring Olea Linux..."

    configure_sway
    configure_waybar
    configure_foot
    configure_shell
    enable_services

    echo "Done. Log out and select Sway from your display manager."
}

main "$@"
