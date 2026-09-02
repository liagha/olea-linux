if [[ -z $WAYLAND_DISPLAY && -z $DISPLAY ]]; then
    case $TTY in
        /dev/tty*) exec sway ;;
    esac
fi