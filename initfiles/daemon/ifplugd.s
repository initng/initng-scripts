# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
. /etc/default/ifplugd
#elsed gentoo
. /etc/conf.d/ifplugd
#endd

setup()
{
	if is_service daemon/ifplugd
	then
		ireg service
		iset need = system/bootmisc
		iset use = system/modules system/coldplug system/ifrename
		iexec start
		iexec stop
		idone
		exit 0
	fi

	ireg daemon #daemon/ifplugd/*
	iset need = system/bootmisc
	iset use = system/modules system/coldplug system/ifrename
	iset stdall = /dev/null
#ifd debian
	iexec daemon
#elsed
	iset exec daemon = "@/usr/sbin/ifplugd@ --no-daemon -i ${NAME}"
#endd
	idone
}

#ifd debian
daemon()
{
	IF1=`echo ${NAME} | @sed@ "s/-/_/"`
	A=`eval echo \$\{ARGS_${IF1}\}`
	[ -z "${A}" ] && A="${ARGS}"

	exec @/usr/sbin/ifplugd@ --no-daemon -i ${NAME} ${A}
}
#endd

start()
{
#ifd debian
	[ "${INTERFACES}" = "auto" -o "${INTERFACES}" = "all" ] &&
#elsed gentoo
	[ "${WIRELESS_INTERFACES}" = "no" -a "${INTERFACES}" = "" ] &&
	OMIT_INTERFACES=$(@awk@ '$1~/^eth|wlan|ath|ra/ {
			gsub( /\W/, "", $1); print $1
		}' < /proc/net/wireless)

	[ "${INTERFACES}" = "" ] &&
#endd
	INTERFACES=$(@awk@ '$1~/^eth|wlan|ath|ra/ {
			gsub( /\W/, "", $1); print $1
		}' < /proc/net/dev)

	for IF in ${INTERFACES}
	do
#ifd gentoo
		@echo@ ${OMIT_INTERFACES} | @/bin/grep@ -qw ${IF} ||
#endd
		@/sbin/ngc@ --instant --quiet -u daemon/ifplugd/${IF} &
	done
	wait
}

stop()
{
	for DAEMON in `@/sbin/ngc@ -s | @awk@ '/daemon/ifplugd/\w+/ { print $2 }'`
	do
		@/sbin/ngc@ --instant --quiet -d ${DAEMON}
	done
}
