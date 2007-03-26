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
NTPOPTIONS=""
source /etc/conf.d/ntp
#endd

setup()
{
	iregister service

	iset need = "system/initial system/mountroot system/mountfs/essential virtual/net"
#ifd debian
	iset exec start = "@/usr/sbin/ntpdate@ -b -s ${NTPOPTIONS} ${NTPSERVERS}"
#elsed gentoo
	iset exec start = "/usr/sbin/ntpdate ${NTPCLIENT_OPTS}"
#elsed
	iset exec start = "@/usr/sbin/ntpdate@ -b -s ${NTPOPTIONS} ${NTPSERVERS}"
#endd

	idone
}
