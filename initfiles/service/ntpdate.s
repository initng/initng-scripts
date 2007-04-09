# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
NTPSERVERS="pool.ntp.org"
NTPOPTIONS=""
source /etc/default/ntpdate
#elsed gentoo
NTPCLIENT_OPTS="-b -s pool.ntp.org"
source /etc/conf.d/ntp-client
#elsed
NTPSERVERS="pool.ntp.org"
[ -f /etc/conf.d/ntp ] && source /etc/conf.d/ntp
#endd

setup()
{
	ireg service service/ntpdate
	iset need = system/initial system/mountfs/essential virtual/net
	iexec start
	idone
}

start()
{
#ifd gentoo
	exec @/usr/sbin/ntpdate@ ${NTPCLIENT_OPTS}
#elsed
	exec @/usr/sbin/ntpdate@ -b -s ${NTPOPTIONS} ${NTPSERVERS}
#endd
}
