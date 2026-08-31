#!/usr/bin/env bash

iso_name="olea"
iso_label="olea_$(date +%Y%m)"
iso_publisher="Olea Linux <https://github.com/liagha/olea-linux>"
iso_application="Olea Linux"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootloader='systemd-boot'
bootodesize="0"
airootfs_image_tool_options=()
airootfs_tree_owner="root:root"
airootfs_tree_mode="0755"

ssh_key="ssh-ed25519 AAAA..."
