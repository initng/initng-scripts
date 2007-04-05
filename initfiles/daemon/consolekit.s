# NAME: consolekit
# DESCRIPTION: Daemon used for user switching stuff
# WWW: http://consolekit.freedesktop.org

setup()
{
	ireg daemon daemon/consolekit
	iset need = system/bootmisc
	iset pid_file = "/var/run/console-kit-daemon.pid"
	iset exec daemon = "@/usr/sbin/console-kit-daemon@"
	idone
}
