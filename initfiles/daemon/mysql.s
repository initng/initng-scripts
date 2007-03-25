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
	iregister -s "daemon/mysql/initdb" service
	iregister -s "daemon/mysql" daemon

	iset -s "daemon/mysql/initdb" need = "system/bootmisc"
	iset -s "daemon/mysql" need = "system/bootmisc virtual/net/lo"
	iset -s "daemon/mysql" use = "daemon/mysql/initdb"
	iset -s "daemon/mysql" pid_file = "${PIDFILE}"

	iexec -s "daemon/mysql/initdb" start = initdb_start
#ifd fedora mandriva
	iexec -s "daemon/mysql" daemon = "@/usr/bin/mysqld_safe@ --pid-file"
#elsed
	iexec -s "daemon/mysql" daemon = "@/usr/bin/mysqld_safe@ --pid-file"
#endd
	iexec -s "daemon/mysql" kill = mysql_kill

	idone -s "daemon/mysql/initdb"
	idone -s "daemon/mysql"
}

initdb_start()
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

mysql_kill()
{
		# Neccesary for mysqld to stop (we have to send the
                # SIGKILL to mysqld itself, but initng has the PID
		# of mysqld_safe - it has to for various reasons)
		kill $(cat ${PIDFILE})
	}
}
