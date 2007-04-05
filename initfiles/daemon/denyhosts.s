# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/denyhosts
	iset need = system/bootmisc
	iset use = daemon/sshd daemon/syslog-ng
#ifd fedora
	iset pid_file = "/var/lock/subsys/denyhosts"
#elsed
	iset pid_file = "/var/run/denyhosts.pid"
#endd
	iset forks
#ifd fedora
	iexec daemon = denyhosts_daemon
#elsed
	iset exec daemon = "@denyhosts@ --daemon -c /etc/denyhosts.conf"
#endd
	idone
}

#ifd fedora
denyhosts_daemon()
{
		export HOSTNAME=$(@/bin/hostname@)
		exec @/usr/bin/denyhosts.py@ --daemon --config /etc/denyhosts.conf
}
#endd
