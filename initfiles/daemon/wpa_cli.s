# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	[ "${SERVICE}" = daemon/wpa_cli ] && return 1

	# system/wpa_cli/*
	ireg daemon && {
		iset need = system/bootmisc
		iset use = system/modules
		iset exec daemon = "@/usr/bin/wpa_cli@ -i${NAME} -p/var/run/wpa_supplicant -P/var/run/wpa_cli-${NAME}.pid -a${INITNG_PLUGIN_DIR}/scripts/net/wpa_cli.action"
	}
}
