# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/dcron && {
		iset need = system/bootmisc
		iset provide = virtual/cron
		iset exec daemon = "@/usr/sbin/crond@ -n"
	}
}
