# NAME: MLDonkey
# DESCRIPTION: Multi-network P2P client.
# WWW: http://mldonkey.sourceforge.net/Main_Page

MLDONKEY_DIR="/home/p2p/mldonkey"
USER="p2p"
NICE="1"
LOG="/var/log/mldonkey.log"
source /etc/conf.d/mldonkey

setup()
{
	export SERVICE="daemon/mldonkey"
	iregister daemon
	iset need = "system/bootmisc virtual/net"
	iset suid = "${USER}"
	iset nice = "${NICE}"
	iset respawn = yes
	iset stdall = "${LOG}"
	iset exec daemon = "@/usr/bin/mlnet@"
	iexec kill
	idone
}

kill()
{
	echo kill | @/usr/bin/netcat:/usr/bin/telnet@ 127.0.0.1 4000 >/dev/null
	@pkill@ mlnet
	exec [ ${?} -le 1 ]
}
