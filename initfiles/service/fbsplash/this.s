# SERVICE: service/fbsplash
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/initial
		iset also_start = service/fbsplash/stop
		iset exec start = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh start"
		iset exec stop = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh shutdown"
	idone
}
