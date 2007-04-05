# NAME: svnserve
# DESCRIPTION: Subversion server daemon
# WWW: http://subversion.tigris.org/

setup()
{
	ireg daemon daemon/svnserve
	iset need = system/bootmisc
	iset exec daemon = "@/usr/bin/svnserve@ --daemon --foreground --root"
	idone
}
