# SERVICE: daemon/distccd
# NAME: distcc
# DESCRIPTION: Distributed compiler daemon
# WWW: http://distcc.samba.org/

#ifd gentoo
DISTCCD_NICE="10"
DISTCCD_OPTS="--port 3632 --log-level critical --allow 192.168.1.0/24"
#elsed
PORT="3632"
ALLOW="192.168.0.0/24"
LISTEN="0.0.0.0"
NICE="10"
#endd

[ -f /etc/conf.d/distccd ] && . /etc/conf.d/distccd

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset suid = distcc
		iexec daemon
	idone
}

daemon() {
#ifd gentoo
	exec @/usr/bin/distccd@ --daemon --no-detach -N ${DISTCCD_NICE} \
				${DISTCCD_OPTS}
#elsed
	exec @/usr/bin/distccd@ --daemon --no-detach -N ${NICE} \
				--port ${PORT} --allow ${ALLOW} \
				--listen ${LISTEN}
#endd
}
