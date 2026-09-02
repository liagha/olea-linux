#!/usr/bin/env bash
# Pacman mirror ranking before base installation.

set_mirrors() {
    step 'pacman mirrors'
    confirm 'refresh mirrors with reflector (Iran)?' || return 0
    need reflector 'reflector'
    reflector --country Iran --protocol https --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
}