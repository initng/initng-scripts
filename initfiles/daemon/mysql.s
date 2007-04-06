# NAME: MySQL
# DESCRIPTION: SQL database server
# WWW: http://www.mysql.com/

#ifd pingwinek enlisy
	DATA="/srv/mysql"
#elsed
	DATA="/var/lib/mysql"
#endd
PIDFILE="/var/run/mysqld/mysqld.pid"

setup()
{
	ireg service aemon/mysql/initdb
	iset need = system/bootmisc
	iexec start = initdb
	idone

	ireg daemon daemon/mysql
	iset need = system/bootmisc virtual/net/lo
	iset use = daemon/mysql/initdb
	iset pid_file = "${PIDFILE}"
#ifd fedora mandriva
	iset exec daemon = "@/usr/bin/mysqld_safe@ --pid-file"
#elsed
	iset exec daemon = "@/usr/bin/mysqld_safe@ --pid-file"
#endd
	iexec kill
	idone
}

initdb()
{
#ifd enlisy
	if [ ! -d ${DATA} ]; then
		@mkdir@ -p ${DATA}
		/usr/bin/mysql_install_db --datadir=${DATA} --user=mysql >/dev/null 2>&1
		chown -R mysql.mysql ${DATA}
	fi
#elsed
	if [ ! -d ${DATA}/db/mysql ]
	then
		if [ ! -d ${DATA} ]
		then
			@mkdir@ -p ${DATA}
			chown mysql.mysql ${DATA}
			chmod go-rwx ${DATA}
		fi
		su mysql -c "/usr/bin/mysql_install_db" >/dev/null 2>&1
	fi
	exec [ -f ${DATA}/db/mysql/db.frm ]
#endd
}

kill()
{
	# Neccesary for mysqld to stop (we have to send the
	# SIGKILL to mysqld itself, but initng has the PID
	# of mysqld_safe - it has to for various reasons)
	kill $(<"${PIDFILE}")
}
