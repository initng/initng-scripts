# NAME: Fetchmail
# DESCRIPTION: Remote mail retrieval and forwarding utility.
# WWW: http://fetchmail.berlios.de/

setup()
{
	ireg daemon daemon/fetchmail && {
		iset need = system/bootmisc daemon/sendmail virtual/net
		iset exec daemon = "@/usr/bin/fetchmail@ -f /etc/fetchmailrc"
	}
}
