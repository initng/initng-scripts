# NAME: consolekit
# DESCRIPTION: Daemon used for user switching stuff
# WWW: http://consolekit.freedesktop.org

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset pid_file = "/var/run/console-kit-daemon.pid"

	iexec daemon = "@/usr/sbin/console-kit-daemon@"

	idone
}

