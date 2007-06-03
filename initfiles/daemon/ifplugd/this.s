# SERVICE: daemon/ifplugd
# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
[ -f /etc/default/ifplugd ] && . /etc/default/ifplugd
#elsed gentoo
[ -f /etc/conf.d/ifplugd ] && . /etc/conf.d/ifplugd
#endd

setup()
{
	iregister service
		iset need = system/bootmisc
		iset use = system/modules system/coldplug system/ifrename
		iexec start
		iexec stop
	idone
}

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
