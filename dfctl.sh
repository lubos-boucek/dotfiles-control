#!/usr/bin/env sh
set -e

. ./subr.sh

PROGNAME="$(basename "$0")"
DIR="$(pwd)"
CONF_DIR="$DIR/conf"
# TODO: let DEBUG be defined before script
DEBUG=1

cmd_install() {
	[ $# -lt 1 ] && errx "no target specified"

	for TARGET in "$@"; do
		install "$TARGET"
	done
}

cmd_uninstall() {
	[ $# -lt 1 ] && errx "no target specified"

	for TARGET in "$@"; do
		uninstall "$TARGET"
	done
}

# load conf/*
# TODO: not ready for tree
# TODO: assuming noone uses blanks in filenames
if [ -d "$CONF_DIR" ]; then
	CONFS="$(find "$CONF_DIR" -type f)"

	for F in $CONFS; do
		[ $DEBUG -gt 0 ] && echo "# loading $F"
		. "$F"
	done
fi

# commands
if [ $# -lt 1 ]; then
	errx "no command specified"
fi

case "$1" in
	copy)
		errx "not implemented yet"
		shift
		cmd_copy "$@"
		;;
	install)
		shift
		cmd_install "$@"
		;;
	uninstall)
		shift
		cmd_uninstall "$@"
		;;
	*)
		errx "unknown command"
esac
