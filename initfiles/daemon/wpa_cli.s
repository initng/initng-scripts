# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	[ "${NAME}" = wpa_cli ] && exit 1

	# SERVICE: system/wpa_cli/*
	iregister daemon
	iset need = "system/bootmisc"
	iset use = "system/modules"
	iset exec daemon = "@/usr/bin/wpa_cli@ -i${NAME} -p/var/run/wpa_supplicant -P/var/run/wpa_cli-${NAME}.pid -a${INITNG_PLUGIN_DIR}/scripts/net/wpa_cli.action"
	idone
}
