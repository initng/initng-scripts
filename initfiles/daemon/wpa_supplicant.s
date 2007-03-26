# NAME: wpa_supplicant
# DESCRIPTION: IEEE802.1x (WPA) encryption for wireless LAN connections
# WWW: http://hostap.epitest.fi/wpa_supplicant

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "system/ifrename system/modules"
	iset pid_file = "/var/run/wpa_supplicant-${NAME}.pid"
	iset forks

	iset exec daemon = wpa_supplicant_any_daemon
	iset exec kill = wpa_supplicant_any_kill

	idone
}

wpa_supplicant_any_daemon()
{
		. ${INITNG_PLUGIN_DIR}/scripts/net/functions

		eval opts=\"\$\{wpa_supplicant_${ifvar}\} -i${iface} -c/etc/wpa_supplicant.conf -B\"
		[ -f /sbin/wpa_cli.action ] && \
				opts="${opts} -w -P/var/run/wpa_supplicant-${iface}.pid"

		@/sbin/wpa_supplicant@ ${opts}

		if [ -f /sbin/wpa_cli.action ]
		then
				@/sbin/ngc@ --quiet --instant -u daemon/wpa_cli/${iface}
				exit 0
		fi

		source "${libdir}/wpa_supplicant"
		if ! wpa_supplicant_associate
		then
				@wpa_cli@ -i${iface} terminate
				exit 1
		fi

		@/sbin/ngc@ --quiet --instant -u net/${iface}
}

wpa_supplicant_any_kill()
{
		@pkill@ -f "/sbin/wpa_supplicant .* -i${NAME} "
}
