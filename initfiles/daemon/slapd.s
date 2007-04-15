# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
[ -f /etc/conf.d/slapd ] && . /etc/conf.d/slapd
#endd

setup()
{
	ireg daemon daemon/slapd && {
		iset need = system/bootmisc
		iset suid = ldap
		iset sgid = ldap
		iset pid_file = "/var/run/openldap/slapd.pid"
		iset forks
#ifd gentoo
		iset exec daemon = "@/usr/lib/openldap/slapd@ -u ldap -g ldap ${OPTS}"
#elsed
		iset exec daemon = "@/usr/lib/openldap/slapd@"
#endd
		iset exec kill = "@killall@ -2 slapd"
	}
}
