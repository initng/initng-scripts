# SERVICE: daemon/postgres/initdb
# NAME: PostgreSQL
# DESCRIPTION: Relational database
# WWW: http://www.postgresql.org/

. /usr/share/postgresql-common/init.d-functions

#ifd pingwinek
PGDATA="/srv/pgsql"
#elsed
PGDATA="/var/lib/postgresql/data"
#endd

PGUSER="postgres"
PGGROUP="postgres"

#ifd gentoo
[ -f /etc/conf.d/postgresql ] && . /etc/conf.d/postgresql
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
	[ -f ${PGDATA}/PG_VERSION ] && exit 0

	if [ ! -d ${PGDATA} ]; then
		@mkdir@ -p ${PGDATA}
		@chown@ ${PGUSER}.${PGGROUP} ${PGDATA}
		@chmod@ go-rwx ${PGDATA}
	fi

	# Initialize the database
	@su@ - ${PGUSER} -c "@/usr/bin/initdb@ --pgdata=${PGDATA} > /dev/null 2>&1" < /dev/null

	exec [ -f ${PGDATA}/PG_VERSION ]
}
