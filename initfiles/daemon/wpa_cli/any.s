# SERVICE: system/wpa_cli/*
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset use = system/modules
		iset exec daemon = "@/usr/bin/wpa_cli@ -i${NAME} -p/var/run/wpa_supplicant -P/var/run/wpa_cli-${NAME}.pid -a${INITNG_MODULE_DIR}/scripts/net/wpa_cli.action"
	idone
}
