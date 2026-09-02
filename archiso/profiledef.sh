#!/usr/bin/env bash
# Olea Linux archiso profile.

iso_name="olea"
iso_label="OLEA_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Olea Linux <https://github.com/liagha/olea-linux>"
iso_application="Olea Linux live and installation medium"
iso_version="$(cat VERSION 2>/dev/null || date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="olea"
arch="x86_64"
buildmodes=('iso')
bootmodes=('uefi.systemd-boot')
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M')
file_permissions=(
    ["/etc/shadow"]="0:0:400"
    ["/root/install.sh"]="0:0:755"
    ["/root/lib/"]="0:0:755"
)