# SERVICE: service/ntpdate
# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
NTPSERVERS="pool.ntp.org"
[ -f /etc/default/ntpdate ] && . /etc/default/ntpdate
#elsed gentoo
NTPCLIENT_OPTS="-b -s pool.ntp.org"
[ -f /etc/conf.d/ntp-client ] && . /etc/conf.d/ntp-client
#elsed
NTPSERVERS="pool.ntp.org"
[ -f /etc/conf.d/ntp ] && . /etc/conf.d/ntp
#endd

setup()
{
	iregister service
		iset need = system/initial system/mountfs/essential virtual/net
#ifd gentoo
		iset exec start = "@/usr/sbin/ntpdate@ ${NTPCLIENT_OPTS}"
#elsed
		iset exec start = "@/usr/sbin/ntpdate@ -b -s ${NTPOPTIONS} ${NTPSERVERS}"
#endd
	idone
}
