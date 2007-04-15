# NAME: NoIP
# DESCRIPTION: Update client for no-ip.com's dynamic IP service
# WWW: http://www.no-ip.com

setup()
{
	ireg daemon daemon/noip && {
		iset need = virtual/net system/bootmisc
		iset pid_of = noip2
		iset respawn
		iset forks
		iset exec daemon = "@/usr/local/bin/noip2@"
	}
}
