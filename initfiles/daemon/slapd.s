# NAME: 
# DESCRIPTION: 
# WWW: 

#ifd gentoo
source /etc/conf.d/slapd
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset suid = ldap
	iset sgid = ldap
	iset pid_file = "/var/run/openldap/slapd.pid"
	iset forks

#ifd gentoo
	iset exec daemon = "@/usr/lib/openldap/slapd@ -u ldap -g ldap ${OPTS}"
#elsed
	iset exec daemon = "@/usr/lib/openldap/slapd@"
#endd
	iset exec kill = "killall -2 slapd"

	idone
}

