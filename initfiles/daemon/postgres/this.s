# SERVICE: daemon/postgres
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

PGLOG="${PGDATA}/postgresql.log"
PGOPTS="-p5432"

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset use = daemon/postgres/initdb
		iset suid = "${PGUSER}"
		iset sgid = "${PGGROUP}"
		iset pid_file = "${PGDATA}/postmaster.pid"
		iset forks
		iset exec daemon = "@/usr/bin/pg_ctl@ -p@/usr/bin/postmaster@ -D${PGDATA} -s -l${PGLOG} -o${PGOPTS} start"
		iset exec kill = "@/usr/bin/pg_ctl@ -D${PGDATA} -s -m fast stop"
	idone
}
