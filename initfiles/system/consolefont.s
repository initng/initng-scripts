# NAME:
# DESCRIPTION:
# WWW:

RC_TTY_NUMBER="11"
#ifd fedora pingwinek mandriva
#elsed lfs
[ -f /etc/sysconfig/console ] && . /etc/sysconfig/console
#elsed debian ubuntu
[ -f /etc/console-tools/config ] && . /etc/console-tools/config
#elsed enlisy
[ -f /etc/conf.d/rc ] && . /etc/conf.d/rc
[ -f /etc/conf.d/rc ] && . /etc/conf.d/consolefont
#elsed
[ -f /etc/rc.conf ] && . /etc/rc.conf
[ -f /etc/conf.d/consolefont ] && . /etc/conf.d/consolefont
#endd

setup()
{
	ireg service system/consolefont && {
		iset need = system/bootmisc system/keymaps
#ifd fedora pingwinek
		iset exec start = "/sbin/setsysfont"
#elsed
		iexec start
#endd
	}
}

#ifd fedora pingwinek
#elsed
start()
{
#ifd debian
	if [ -d /etc/console-tools/config.d ]
	then
		for i in `@run-parts@ --list /etc/console-tools/config.d`
		do
			. ${i}
		done
	fi
#endd
	[ -n "${SCREEN_FONT}" ] && CONSOLEFONT="${SCREEN_FONT}"
	[ -n "${SYSFONT}" ] && CONSOLEFONT="${SYSFONT}"
	[ -n "${FONT}" ] && CONSOLEFONT="${FONT}"

	if [ -z "${CONSOLEFONT}" ]
	then
		echo "Using the default console font"
		exit 0
	fi

	retval=1

	if [ -x @/bin/setfont@ ]
	then
		SETFONT=@/bin/setfont@
	elif [ -x @/usr/bin/consolechars@ ]
	then
		SETFONT=@/usr/bin/consolechars@
		CONSOLEFONT="-f '${CONSOLEFONT}'"
	else
		echo "Could not find set font utils ..."
		exit 1
	fi
	# Get additional parameters
	[ -n "${CONSOLETRANSLATION}" ] && param="-m ${CONSOLETRANSLATION}"
	if [ -n "${SYSFONTACM}" ]
	then
		[ -f "/lib/kbd/consoletrans/${SYSFONTACM}_to_uni.trans" ] || SYSFONTACM=`echo ${SYSFONTACM} | @sed@ "s|iso0|8859-|g;s|iso|8859-|g"`
		ARGS="${ARGS} -m ${SYSFONTACM}"
	fi

	# Set the console font
	# We patched setfont to have --tty support ...
	if ${SETFONT} --help 2>&1 | @grep@ -qe --tty || ${SETFONT} --help 2>&1 | @grep@ -qe -C
	then
		if ${SETFONT} --help 2>&1 | @grep@ -qe --tty
		then
			sf_param="--tty="
		else
			sf_param="-C "
		fi

		for x in `@seq@ 1 ${RC_TTY_NUMBER}`
		do
			${SETFONT} ${CONSOLEFONT} ${param} \
			${sf_param}/dev/tty${x} >/dev/null
			retval=0
		done
	else
		${SETFONT} ${CONSOLEFONT} ${param} >/dev/null
		retval=0
	fi
	exit ${retval}
}
#endd
