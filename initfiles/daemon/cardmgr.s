# SERVICE: daemon/cardmgr
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc system/pcmcia
		iset pid_file = "/var/run/cardmgr.pid"
		iset forks
		iset exec daemon = "@/sbin/cardmgr@ -s /var/run/stab"
	idone
}
