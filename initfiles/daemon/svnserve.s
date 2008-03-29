# SERVICE: daemon/svnserve
# NAME: svnserve
# DESCRIPTION: Subversion server daemon
# WWW: http://subversion.tigris.org/

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset exec daemon = "@/usr/bin/svnserve@ --daemon --foreground --root"
	idone
}
