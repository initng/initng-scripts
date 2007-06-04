# SERVICE: service/fbsplash/stop
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister task
		iset need = system/initial
		iset just_before = daemon/gdm daemon/kdm daemon/xdm \
		                   daemon/wdm daemon/entranced
		iset exec task = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh stop"
	idone
}
