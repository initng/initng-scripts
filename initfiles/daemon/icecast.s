# SERVICE: daemon/icecast
# NAME: icecast
# DESCRIPTION: Multi-format streaming audio server
# WWW: http://www.icecast.org/

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset respawn
		iset exec daemon = "@/usr/bin/icecast@ -c /etc/icecast2/icecast.xml"
	idone
}
