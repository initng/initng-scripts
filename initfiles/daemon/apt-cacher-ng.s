# SERVICE: daemon/apt-chacher-ng
# NAME: apt-cacher-ng
# DESCRIPTION: Apt-Cacher NG package proxy
# WWW:

RUNDIR = /var/run/apt-cacher-ng;
PIDFILE = ${RUNDIR}/pid;
SOCKET = ${RUNDIR}/socket;
 
setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset suid = apt-cacher-ng
		iset sgid = apt-cacher-ng
		iset exec daemon = /usr/sbin/apt-cacher-ng \
			-c /etc/apt-cacher-ng pidfile=${PIDFILE} \
			SocketPath=${SOCKET} foreground=1
		iexec kill
       };
}

kill() {
	killall apt-cacher-ng
	rm -f ${PIDFILE} ${SOCKET}
}
