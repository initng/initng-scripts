# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister -s "service/fbsplash/start" service
	iregister -s "service/fbsplash/stop" service
	iregister -s "service/fbsplash" virtual

	iset -s "service/fbsplash/start" need = "system/initial"
	iset -s "service/fbsplash/start" exec start = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh start"
	iset -s "service/fbsplash/start" exec stop = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh shutdown"
	iset -s "service/fbsplash/stop" need = "system/initial"
	iset -s "service/fbsplash/stop" just_before = "daemon/gdm daemon/kdm daemon/xdm daemon/wdm daemon/entranced"
	iset -s "service/fbsplash/stop" exec start = "${INITNG_PLUGIN_DIR}/scripts/splash/fbsplash.sh stop"
	iset -s "service/fbsplash" need = "service/fbsplash/start service/fbsplash/stop"


	idone -s "service/fbsplash/start"
	idone -s "service/fbsplash/stop"
	idone -s "service/fbsplash"
}
