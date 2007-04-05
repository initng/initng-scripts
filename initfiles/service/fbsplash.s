# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service service/fbsplash/start
	iset need = system/initial
	iset exec start = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh start"
	iset exec stop = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh shutdown"
	idone

	iregister service service/fbsplash/stop
	iset need = system/initial
	iset just_before = daemon/gdm daemon/kdm daemon/xdm daemon/wdm \
	                   daemon/entranced
	iset exec start = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh stop"
	idone

	iregister virtual service/fbsplash
	iset need = service/fbsplash/start service/fbsplash/stop
	idone
}
