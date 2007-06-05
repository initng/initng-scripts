# SERVICE: service/fbsplash/stop
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/initial
		iset just_before = daemon/gdm daemon/kdm daemon/xdm \
		                   daemon/wdm daemon/entranced
		iset exec start = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh stop"
	idone
}
