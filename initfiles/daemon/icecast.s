# NAME: icecast
# DESCRIPTION: Multi-format streaming audio server
# WWW: http://www.icecast.org/

setup()
{
	ireg daemon daemon/icecast && {
		iset need = system/bootmisc
		iset respawn
		iset exec daemon = "@/usr/bin/icecast@ -c /etc/icecast2/icecast.xml"
	}
}
