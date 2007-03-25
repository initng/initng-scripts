# NAME: 
# DESCRIPTION: 
# WWW: 

#ifd debian
source /etc/default/ifplugd
#endd
#ifd debian
source /etc/default/ifplugd
#elsed gentoo
source /etc/conf.d/ifplugd
#endd

setup()
{
	iregister -s "daemon/ifplugd/*" daemon
	iregister -s "daemon/ifplugd" service

	iset -s "daemon/ifplugd/*" need = "system/bootmisc"
	iset -s "daemon/ifplugd/*" use = "system/modules system/coldplug system/ifrename"
	iset -s "daemon/ifplugd/*" stdall = /dev/null
	iset -s "daemon/ifplugd" need = "system/bootmisc"
	iset -s "daemon/ifplugd" use = "system/modules system/coldplug system/ifrename"

#ifd debian
	iexec -s "daemon/ifplugd/*" daemon = ifplugd_any_daemon
#elsed
	iexec -s "daemon/ifplugd/*" daemon = "@/usr/sbin/ifplugd@ --no-daemon -i ${NAME}"
#endd
	iexec -s "daemon/ifplugd" start = ifplugd_start
	iexec -s "daemon/ifplugd" stop = ifplugd_stop

	idone -s "daemon/ifplugd/*"
	idone -s "daemon/ifplugd"
}

#ifd debian
ifplugd_any_daemon()
{
		IF1=`echo ${NAME} | @sed@ "s/-/_/"`
		A=`eval echo \$\{ARGS_${IF1}\}`
		[ -z "${A}" ] && A="${ARGS}"

		exec @/usr/sbin/ifplugd@ --no-daemon -i ${NAME} ${A};
}
#endd

ifplugd_start()
{
#ifd debian
		[ "${INTERFACES}" = "auto" -o "${INTERFACES}" = "all" ] && \
#elsed gentoo
		[ "${WIRELESS_INTERFACES}" = "no" -a "${INTERFACES}" = "" ] && \
		OMIT_INTERFACES=$(@awk@ '$1~/^eth|wlan|ath|ra/ {
				gsub( /\W/, "", $1); print $1
			}' < /proc/net/wireless)

		[ "${INTERFACES}" = "" ] && \
#endd
		INTERFACES=$(@awk@ '$1~/^eth|wlan|ath|ra/ {
				gsub( /\W/, "", $1); print $1
			}' < /proc/net/dev)

		for IF in ${INTERFACES}
		do
#ifd gentoo
				@echo@ ${OMIT_INTERFACES} | @/bin/grep@ -qw ${IF} || \
#endd
				@/sbin/ngc@ --quiet -u daemon/ifplugd/${IF} &
		done
		wait
}

ifplugd_stop()
{
		for DAEMON in `@/sbin/ngc@ -s | @awk@ '/daemon/ifplugd/\w+/ { print $2 }'`
		do
			@/sbin/ngc@ --quiet -d ${DAEMON} &
		done
		wait
}
