#!/sbin/runiscript

#ifd debian linspire

CONFDIR=/etc/console
CONFFILEROOT=boottime
EXT=kmap
CONFFILE=${CONFDIR}/${CONFFILEROOT}.${EXT}.gz

#elsed fedora pingwinek

source /etc/sysconfig/keyboard

#elsed gentoo

source /etc/rc.conf
source /etc/conf.d/keymaps

#endd


setup()
{
    iregister service
    iset need = "bootmisc sysctl"
	iexec start
    idone
}

start()
{
#ifd fedora
		if [ -n "${KEYTABLE}" -a -d "/lib/kbd/keymaps" ]
		then
			KEYMAP="${KEYTABLE}.map"
		fi
#endd
#ifd debian linspire
		# Don't fail on error
		CONSOLE_TYPE=`fgconsole 2>/dev/null` || CONSOLE_TYPE="unknown"
		# fail silently if loadkeys not present (yet).
		command -v loadkeys >/dev/null 2>&1 || exit 0

		unicode_start_stop() {
			# Switch unicode mode by checking the locale.
			# This will be needed before loading the keymap.
			[ -x @unicode_start@ ] || [ -x @unicode_start@ ] || return
			[ -x @unicode_stop@ ] || [ -x @unicode_stop@ ] || return
			[ -r /etc/environment ] || return

			for var in LANG LC_ALL LC_CTYPE
			do
				value=`@egrep@ "^[^#]*${var}=" /etc/environment | @tail@ -n1 | @cut@ -d= -f2`
				eval ${var}=${value}
			done

			CHARMAP=`LANG=${LANG} LC_ALL=${LC_ALL} LC_CTYPE=${LC_CTYPE} locale charmap`
			if [ "${CHARMAP}" = "UTF-8" ]
			then
				@unicode_start@
			else
				@unicode_stop@
			fi >/dev/null 2>&1
			true
		}

		# First mount /proc if necessary.
		unmount_proc="no"
		if [ ! -x /proc/1 ]
		then
			unmount_proc="yes"
			@mount@ -n /proc
		fi

		if [ -f /proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes ]
		then
			linux_keycodes=`@cat@ /proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes`
		else
			linux_keycodes=1
		fi

		# load new map
		if [ "${linux_keycodes}" -gt 0 ]
		then
			if [ -r "${CONFFILE}" ]
			then
				# Switch console mode to UTF-8 or ASCII as necessary
				unicode_start_stop
				if [ "${CONSOLE_TYPE}" = "serial" ]
				then
					@/bin/loadkeys@ -q ${CONFFILE} 2>&1 >/dev/null
				else
					@/bin/loadkeys@ -q ${CONFFILE}
				fi
				if [ ${?} -gt 0 ]
				then
					# if we've a serial console, we may not have a keyboard, so don't
					# complain if we fail.
					[ "${CONSOLE_TYPE}" = "serial" ] && exit 0
					echo "Problem when loading ${CONFDIR}/${CONFFILEROOT}.${EXT}.gz, use install-keymap"
					sleep 10
				fi
			fi
		fi

		# unmount /proc if we mounted it
		[ "${unmount_proc}" = "no" ] || @/bin/umount@ -n /proc
#elsed
		if [ -e /etc/console/boottime.kmap.gz ]
		then
			@/bin/loadkeys@ -q /etc/console/boottime.kmap.gz >/dev/null 2>&1
			exit 0
		fi

		WINDOWKEYS_KEYMAP=

		# Force linux keycodes for PPC.
		[ -f /proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes ] && \
			echo 1 >/proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes

		# New kbd support.
		if [ -x @/bin/loadkeys@ ]
		then
			[ "${SET_WINDOWKEYS}" = "yes" ] && WINDOWKEYS_KEYMAP="windowkeys"
			@/bin/loadkeys@ -q ${WINDOWKEYS_KEYMAP} ${KEYMAP} ${EXTENDED_KEYMAPS} >/dev/null 2>&1
		else
			echo "/bin/loadkeys not found" >&2
			exit 1
		fi

		# Set terminal encoding to either ASCII or UNICODE.
		# See utf-8(7) for more information.
		termencoding=
		if [ "${UNICODE}" = "yes" ]
		then
			dumpkey_opts=""
			[ -n "${DUMPKEYS_CHARSET}" ] && dumpkey_opts="-c ${DUMPKEYS_CHARSET}"
			@/usr/bin/kbd_mode@ -u
			@dumpkeys@ ${dumpkey_opts} | loadkeys --unicode
			termencoding=`@printf@ '\033%%G'`
		else
			termencoding=`@printf@ '\033(K'`
		fi

		[ -d /dev/vc ] && ttydev=/dev/vc/ || ttydev=/dev/tty
		for n in `@seq@ 1 11`
		do
			echo -n ${termencoding} >${ttydev}${n}
		done
#endd
}
