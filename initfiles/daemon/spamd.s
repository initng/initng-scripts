# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/spamd && {
		iset need = system/bootmisc virtual/net
		iset stdall = /dev/null
		iset exec daemon = "@/usr/bin/spamd@ -c"
	}
}
