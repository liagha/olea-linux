#!/usr/bin/env bash
# Shared helpers for the Olea Linux installer.

step() {
    printf '\n== %s ==\n' "$*"
}

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

need() {
    command -v "$1" >/dev/null || die "missing $1 (install $2)"
}

ask() {
    local q="$1" d="${2:-}" t=""
    if [[ -n ${preset[$q]:-} ]]; then
        printf '%s\n' "${preset[$q]}"
        return
    fi
    if [[ ! -t 0 ]]; then
        [[ -n $d ]] && printf '%s\n' "$d" || die "$q requires input"
        return
    fi
    if [[ -n $d ]]; then
        printf '%s [%s]: ' "$q" "$d"
    else
        printf '%s: ' "$q"
    fi
    IFS= read -r t || return 1
    printf '%s\n' "${t:-$d}"
}

pass() {
    local q="$1" k="$2" a="" b=""
    if [[ -n ${preset[$k]:-} ]]; then
        printf '%s\n' "${preset[$k]}"
        return
    fi
    [[ -t 0 ]] || die "$q requires input"
    read -rsp "$q: " a || die 'cannot read password'
    printf '\n' >&2
    read -rsp "$q again: " b || die 'cannot read password'
    printf '\n' >&2
    [[ $a == "$b" ]] || die 'passwords do not match'
    printf '%s\n' "$a"
}

confirm() {
    local q="$1" a=""
    [[ ${preset[yes]:-no} == yes ]] && return 0
    printf '%s [yes]: ' "$q"
    IFS= read -r a || return 1
    [[ $a == yes ]]
}

in_chroot() {
    arch-chroot "$target" "$@"
}