# SERVICE: daemon/mysql/initdb
# NAME: MySQL
# DESCRIPTION: SQL database server
# WWW: http://www.mysql.com/

#ifd pingwinek enlisy
DATA="/srv/mysql"
#elsed
DATA="/var/lib/mysql"
#endd

setup()
{
	iregister service
		iset need = system/bootmisc
		iexec start
	idone
}

start()
{
#ifd enlisy
	if [ ! -d ${DATA} ]; then
		@mkdir@ -p ${DATA}
		/usr/bin/mysql_install_db --datadir=${DATA} --user=mysql >/dev/null 2>&1
		chown -R mysql.mysql ${DATA}
	fi
#elsed
	if [ ! -d ${DATA}/db/mysql ]; then
		if [ ! -d ${DATA} ]; then
			@mkdir@ -p ${DATA}
			chown mysql.mysql ${DATA}
			chmod go-rwx ${DATA}
		fi
		su mysql -c "/usr/bin/mysql_install_db" >/dev/null 2>&1
	fi
	exec [ -f ${DATA}/db/mysql/db.frm ]
#endd
}
