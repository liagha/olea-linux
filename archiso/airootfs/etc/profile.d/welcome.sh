#!/usr/bin/env bash
# Live environment welcome banner.

if [[ -z ${OLEA_WELCOME_SH:-} ]]; then
    export OLEA_WELCOME_SH=1
    cat <<'EOF'

  Olea Linux live environment

  To install Olea Linux on this machine:

    /root/install.sh

EOF
fi