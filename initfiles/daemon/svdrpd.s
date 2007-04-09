# NAME:
# DESCRIPTION:
# WWW:

VDR_HOST="localhost"
VDR_PORT="2002"
SERV_HOST="localhost"
SERV_PORT="2001"
[ -f /etc/conf.d/svdrpd ] && . /etc/conf.d/svdrpd

setup()
{
	ireg daemon daemon/svdrpd
	iset need = system/bootmisc
	iset use = daemon/vdr
	iset respawn
	iexec daemon
	idone
}

daemon()
{
	exec @/usr/bin/svdrpd@ "${VDR_HOST}" "${VDR_PORT}" "${SERV_HOST}" \
	                       "${SERV_PORT}"
}
