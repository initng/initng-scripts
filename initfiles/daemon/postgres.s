# NAME: PostgreSQL
# DESCRIPTION: Relational database
# WWW: http://www.postgresql.org/

. /usr/share/postgresql-common/init.d-functions

#ifd debian
#elsed
#ifd pingwinek
PGDATA="/srv/pgsql"
#elsed
PGDATA="/var/lib/postgresql/data"
#endd
PGUSER="postgres"
PGGROUP="postgres"
#ifd gentoo
. /etc/conf.d/postgresql
#endd
#ifd pingwinek
PGDATA="/srv/pgsql"
#elsed
PGDATA="/var/lib/postgresql/data"
#endd
PGUSER="postgres"
PGGROUP="postgres"
PGLOG="${PGDATA}/postgresql.log"
PGOPTS="-p5432"
#ifd gentoo
. /etc/conf.d/postgresql
#endd
#endd

setup()
{
#ifd debian
	ireg daemon #daemon/postgres/*
	iset need = system/bootmisc
	iset provide = virtual/postgres
	iset suid = postgres
	iset sgid = postgres
	iset pid_file = "/var/run/postgresql/${NAME}-main.pid"
	iset forks
	iexec daemon
	iexec kill
	idone
#elsed
	ireg service daemon/postgres/initdb
	iset need = system/bootmisc
	iexec start = initdb_start
	idone

	ireg daemon daemon/postgres
	iset need = system/bootmisc
	iset use = daemon/postgres/initdb
	iset suid = "${PGUSER}"
	iset sgid = "${PGGROUP}"
	iset pid_file = "${PGDATA}/postmaster.pid"
	iset forks
	iexec daemon
	iset exec kill = "@/usr/bin/pg_ctl@ -D${PGDATA} -s -m fast stop"
	idone
#endd

}

#ifd debian
daemon()
{
	start ${NAME}
}

kill()
{
	stop ${NAME}
}
#elsed

initdb_start()
{
	[ -f ${PGDATA}/PG_VERSION ] && exit 0

	if [ ! -d ${PGDATA} ]
	then
		@mkdir@ -p ${PGDATA}
		@chown@ ${PGUSER}.${PGGROUP} ${PGDATA}
		@chmod@ go-rwx ${PGDATA}
	fi

	# Initialize the database
	@su@ - ${PGUSER} -c "@/usr/bin/initdb@ --pgdata=${PGDATA} > /dev/null 2>&1" < /dev/null

	exec [ -f ${PGDATA}/PG_VERSION ]
}

daemon()
{
	exec @/usr/bin/pg_ctl@ -p@/usr/bin/postmaster@ -D"${PGDATA}" -s -l"${PGLOG}" -o"${PGOPTS}" start
}
#endd
