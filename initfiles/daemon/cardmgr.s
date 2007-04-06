# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/cardmgr
	iset need = system/bootmisc system/pcmcia
	iset pid_file = "/var/run/cardmgr.pid"
	iset forks
	iset exec daemon = "@/sbin/cardmgr@ -s /var/run/stab"
	idone
}
