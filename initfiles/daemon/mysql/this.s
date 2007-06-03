# SERVICE: daemon/mysql
# NAME: MySQL
# DESCRIPTION: SQL database server
# WWW: http://www.mysql.com/

PIDFILE="/var/run/mysqld/mysqld.pid"

setup()
{
	iregister daemon
		iset need = system/bootmisc virtual/net/lo
		iset use = daemon/mysql/initdb
		iset pid_file = "$PIDFILE"
		iset exec daemon = "@/usr/bin/mysqld_safe@ --pid-file $PIDFILE"
	idone
}
