#!/usr/bin/env sh
set -e

. ./subr.sh

PROGNAME="$(basename "$0")"
DFM_DIR="${DFM_DIR:="$(pwd)"}"
DFM_CONF_DIR="${DFM_CONF_DIR:="$DFM_DIR/conf"}"
# TODO: sanitate DEBUG
DFM_DEBUG=${DFM_DEBUG:=0}

cmd_generic() {
	[ $# -lt 2 ] && errx "no target specified"
	CMD="$1"
	shift

	for TARGET in "$@"; do
		"$CMD" "$TARGET"
	done
}

#cmd_uninstall() {
#	[ $# -lt 1 ] && errx "no target specified"
#
#	for TARGET in "$@"; do
#		uninstall "$TARGET"
#	done
#}

# load $CONF_DIR
if [ -d "$DFM_CONF_DIR" ]; then
	CONFS="$(find "$DFM_CONF_DIR" -type f)"

	for CONF in $CONFS; do
		[ $DFM_DEBUG -gt 0 ] && echo "# loading $CONF"
		. "$CONF"
	done
fi

# commands
if [ $# -lt 1 ]; then
	errx "no command specified"
fi

case "$1" in
	copy)
		errx "not implemented yet"
		#shift
		#cmd_copy "$@"
		;;
	install|uninstall)
		cmd_generic "$@"
		;;
	*)
		errx "unknown command"
esac
