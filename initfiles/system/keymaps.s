# SERVICE: system/keymaps
# NAME:
# DESCRIPTION:
# WWW:

ttydev="/dev/tty"
#ifd debian linspire
CONFDIR="/etc/console"
CONFFILEROOT="boottime"
EXT="kmap"
CONFFILE="${CONFDIR}/${CONFFILEROOT}.${EXT}.gz"
#elsed lfs
[ -f /etc/sysconfig/console ] && . /etc/sysconfig/console
#elsed fedora pingwinek mandriva
[ -f /etc/sysconfig/keyboard ] && . /etc/sysconfig/keyboard
#elsed enlisy
[ -f /etc/conf.d/rc ] && . /etc/conf.d/rc
[ -f /etc/conf.d/keymaps ] && . /etc/conf.d/keymaps
#elsed gentoo
[ -f /etc/rc.conf ] && . /etc/rc.conf
[ -f /etc/conf.d/keymaps ] && . /etc/conf.d/keymaps
#elsed sourcemage
[ -f /etc/sysconfig/keymap ] && . /etc/sysconfig/keymap
#elsed
[ -f /etc/keymaps.conf ] && . /etc/keymaps.conf
#endd

setup() {
	iregister service
		iset need = system/bootmisc
		iset use = system/sysctl
		iexec start
	idone
}

start() {
#ifd fedora
	[ -n "${KEYTABLE}" -a -d "/lib/kbd/keymaps" ] &&
		KEYMAP="${KEYTABLE}.map"
#endd
#ifd debian linspire
	# Don't fail on error
	CONSOLE_TYPE=$(fgconsole 2>/dev/null) || CONSOLE_TYPE="unknown"
	# fail silently if loadkeys not present (yet).
	command -v loadkeys >/dev/null 2>&1 || exit 0

	unicode_start_stop() {
		# Switch unicode mode by checking the locale.
		# This will be needed before loading the keymap.
		[ -x @unicode_start@ -a -x @unicode_stop@ -a -r /etc/environment ] || return

		if
			CHARMAP=$(sh -c '
					. /etc/environment >/dev/null 2>&1
					@locale@ charmap
				')
		[ "${CHARMAP}" = "UTF-8" ]
		then
			@unicode_start@
		else
			@unicode_stop@
		fi >/dev/null 2>&1
		true
	}

	if [ -f /proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes ]; then
		linux_keycodes=`@cat@ /proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes`
	else
		linux_keycodes=1
	fi

	# load new map
	if [ "${linux_keycodes}" -gt 0 -a -r "${CONFFILE}" ]; then
		# Switch console mode to UTF-8 or ASCII as necessary
		unicode_start_stop
		if
			if [ "${CONSOLE_TYPE}" = "serial" ]; then
				@/bin/loadkeys@ -q ${CONFFILE} 2>&1 >/dev/null
			else
				@/bin/loadkeys@ -q ${CONFFILE}
			fi
		then
			# if we've a serial console, we may not have a keyboard, so don't
			# complain if we fail.
			[ "${CONSOLE_TYPE}" = "serial" ] && exit 0
			echo "Problem when loading ${CONFFILE}, use install-keymap"
			sleep 10
		fi
	fi
#elsed
	if [ -e /etc/console/boottime.kmap.gz ]; then
		@/bin/loadkeys@ -q /etc/console/boottime.kmap.gz >/dev/null 2>&1
		exit 0
	fi

	WINDOWKEYS_KEYMAP=

	# Force linux keycodes for PPC.
	[ -f /proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes ] &&
		echo 1 >/proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes

	# New kbd support.
	if [ -x @/bin/loadkeys@ ]; then
		[ "${SET_WINDOWKEYS}" = "yes" ] && WINDOWKEYS_KEYMAP="windowkeys"
		@/bin/loadkeys@ -q ${WINDOWKEYS_KEYMAP} ${KEYMAP} ${EXTENDED_KEYMAPS} >/dev/null 2>&1
	else
		echo "@/bin/loadkeys@ not found" >&2
		exit 1
	fi

	# Set terminal encoding to either ASCII or UNICODE.
	# See utf-8(7) for more information.
	termencoding=
#ifd sourcemage
	if [ -n "${UNICODE_START}" ]; then
#elsed
	if [ "${UNICODE}" = "yes" ]; then
#endd
		dumpkey_opts=""
		[ -n "${DUMPKEYS_CHARSET}" ] && dumpkey_opts="-c ${DUMPKEYS_CHARSET}"
		@/usr/bin/kbd_mode@ -u
		@dumpkeys@ ${dumpkey_opts} | loadkeys --unicode
		termencoding='\033%G'
	else
		termencoding='\033(K'
	fi

	for n in `@seq@ 1 11`; do
		printf "${termencoding}" >${ttydev}${n}
	done
#endd
}
