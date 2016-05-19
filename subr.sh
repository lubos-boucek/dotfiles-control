#!/usr/bin/env sh
# TODO: conf/ wouldn't work with subdirs now
# TODO: check for non-existent targets earlier
# TODO: circular dependency
# TODO: find duplicate basenames
errx() {
	echo "$PROGNAME: $@" >&2
	exit 1
}

warnx() {
	echo "WARNING: $@" >&2
}

# based on target name, return path to conf. file
find_conf() {
	[ $# -ne 1 ] && errx "incorrect usage of find_conf"

	for F in $CONFS; do
		if [ "$(basename "$F")" = "$1" ]; then
			echo "$F"
			return 0
		fi
	done

	return 1
}

# check whether a command exists
check() {
	[ $# -ne 1 ] && errx "incorrect usage of check"

	command -V "$1" 2>&1 > /dev/null
}

install() {
	[ $# -ne 1 ] && errx "incorrect usage of install"
	echo "preparing to install $1..."
	
	if check check_$1; then
		if check_$1; then
			echo "$1 already installed!"
			return 0
		fi
	else
		# TODO: decide: is it OK to continue?
		warnx "could not check if $1 is already installed!"
		warnx "continuing anyway!"
	fi
	
	# TODO: decide: kill it?
	CONF="$(find_conf "$1")" || { warnx "target invalid!"; return 1; }
	DEPS="$(grep '^DEPENDENCIES=' "$CONF" | tail -n 1 | cut -d'=' -f'2' | tr ',' ' ')"
	for DEP in $DEPS; do
		[ $DEBUG -gt 0 ] && echo "# dependency $DEP found"
		install "$DEP"
	done

	if check install_$1; then
		echo "installing $1..."
		install_$1
	else
		# TODO: again, decide...
		warnx "could not install $1!"
		warnx "continuing anyway!"
	fi
}

uninstall() {
	[ $# -ne 1 ] && errx "incorrect usage of uninstall"
	echo "preparing to uninstall $1..."
	
	if check check_$1; then
		if ! check_$1; then
			echo "$1 not installed!"
			return 0
		fi
	else
		# TODO: decide: is it OK to continue?
		warnx "could not check if $1 is already installed!"
		warnx "continuing anyway!"
	fi
	
	[ $DEBUG -gt 0 ] && echo "# checking dependencies on $1..."
    for CONF in $CONFS; do
		DEPS=$(grep '^DEPENDENCIES=' $CONF | tail -n 1 | cut -d'=' -f'2' | tr ',' ' ')
		for DEP in $DEPS; do
			if [ "$DEP" = "$1" ]; then
				echo "$(basename "$CONF") is depending"
				uninstall "$(basename "$CONF")"
				break
			fi
		done
	done

	if check uninstall_$1; then
		echo "uninstalling $1..."
		uninstall_$1
	else
		# TODO: again, decide...
		warnx "could not uninstall $1!"
		warnx "continuing anyway!"
	fi
}
