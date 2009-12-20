# SERVICE: daemon/consolekit
# NAME: consolekit
# DESCRIPTION: Daemon used for user switching stuff
# WWW: http://consolekit.freedesktop.org

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset exec daemon = "@/usr/sbin/console-kit-daemon@ --no-daemon"
	idone
}
