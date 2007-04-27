# NAME: spamassassin
# DESCRIPTION: Spam filter
# WWW:

#ifd debian
[ -f /etc/default/spamassassin ] && . /etc/default/spamassassin
#else
OPTIONS="-c"
#endd

setup()
{
	ireg daemon daemon/spamd && {
		iset need = system/bootmisc virtual/net
		iset stdall = /dev/null
		iset exec daemon = "@/usr/sbin/spamd:/usr/bin/spamd@ ${OPTIONS}"
	}
}
