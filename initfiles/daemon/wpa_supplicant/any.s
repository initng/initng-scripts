# SERVICE: daemon/wpa_supplicant/*
# NAME: wpa_supplicant
# DESCRIPTION: IEEE802.1x (WPA) encryption for wireless LAN connections
# WWW: http://hostap.epitest.fi/wpa_supplicant

#ifd gentoo
CONFFILE=/etc/wpa_supplicant/wpa_supplicant.conf
#elsed
CONFFILE=/etc/wpa_supplicant.conf
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset use = system/ifrename system/modules
		iset pid_file = "/var/run/wpa_supplicant-${NAME}.pid"
		iset forks
		iexec daemon
		iexec kill
	idone
}

daemon()
{
	. ${INITNG_PLUGIN_DIR}/scripts/net/functions

	eval opts=\"\$\{wpa_supplicant_${ifvar}\} -i${iface} -c/etc/${CONFFILE} -B\"
	[ -f /sbin/wpa_cli.action ] &&
		opts="${opts} -w -P/var/run/wpa_supplicant-${iface}.pid"

	@/sbin/wpa_supplicant@ ${opts}

	if [ -f /sbin/wpa_cli.action ]; then
		@/sbin/ngc@ --quiet --instant -u daemon/wpa_cli/${iface}
		exit 0
	fi

	. "${libdir}/wpa_supplicant"
	if ! wpa_supplicant_associate; then
		@wpa_cli@ -i${iface} terminate
		exit 1
	fi

	@/sbin/ngc@ --quiet --instant -u net/${iface}
}

kill()
{
	@pkill@ -f "/sbin/wpa_supplicant .* -i${NAME} "
}
