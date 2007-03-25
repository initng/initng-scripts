# NAME: svnserve
# DESCRIPTION: Subversion server daemon
# WWW: http://subversion.tigris.org/

setup()
{
	iregister daemon

	iset need = "system/bootmisc"

	iexec daemon = "@/usr/bin/svnserve@ --daemon --foreground --root"

	idone
}

