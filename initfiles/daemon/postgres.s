# NAME: PostgreSQL
# DESCRIPTION: Relational database
# WWW: http://www.postgresql.org/

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
source /etc/conf.d/postgresql
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
source /etc/conf.d/postgresql
#endd
#endd

setup()
{
#ifd debian
	iregister -s "daemon/postgres/*" daemon
#elsed
	iregister -s "daemon/postgres/initdb" service
	iregister -s "daemon/postgres" daemon
#endd

#ifd debian
	iset -s "daemon/postgres/*" need = "system/bootmisc"
	iset -s "daemon/postgres/*" use = "daemon/postgres/initdb/${NAME}"
	iset -s "daemon/postgres/*" provide = "virtual/postgres"
	iset -s "daemon/postgres/*" suid = postgres
	iset -s "daemon/postgres/*" sgid = postgres
	iset -s "daemon/postgres/*" pid_file = "/var/run/postgresql/${NAME}-main.pid"
	iset -s "daemon/postgres/*" forks
#elsed
	iset -s "daemon/postgres/initdb" need = "system/bootmisc"
	iset -s "daemon/postgres" need = "system/bootmisc"
	iset -s "daemon/postgres" use = "daemon/postgres/initdb"
	iset -s "daemon/postgres" suid = ${PGUSER}
	iset -s "daemon/postgres" sgid = ${PGGROUP}
	iset -s "daemon/postgres" pid_file = "${PGDATA}/postmaster.pid"
	iset -s "daemon/postgres" forks
#endd

#ifd debian
	iexec -s "daemon/postgres/*" daemon = postgres_any_daemon
	iexec -s "daemon/postgres/*" kill = postgres_any_kill
#elsed
	iexec -s "daemon/postgres/initdb" start = initdb_start
	iexec -s "daemon/postgres" daemon = postgres_daemon
	iexec -s "daemon/postgres" kill = "@/usr/bin/pg_ctl@ -D${PGDATA} -s -m fast stop"
#endd

#ifd debian
	idone -s "daemon/postgres/*"
#elsed
	idone -s "daemon/postgres/initdb"
	idone -s "daemon/postgres"
#endd
}

#ifd debian
postgres_any_daemon()
{
                . /usr/share/postgresql-common/init.d-functions
                start ${NAME}
}

postgres_any_kill()
{
                . /usr/share/postgresql-common/init.d-functions
                stop ${NAME}
}
#elsed

initdb_start()
{
            if [ ! -f ${PGDATA}/PG_VERSION ]
            then
                if [ ! -d ${PGDATA} ]
                then
                    @mkdir@ -p ${PGDATA}
                    chown ${PGUSER}.${PGGROUP} ${PGDATA}
                    chmod go-rwx ${PGDATA}
                fi
                # Initialize the database
                su - ${PGUSER} -c "@/usr/bin/initdb@ --pgdata=${PGDATA} > /dev/null 2>&1" < /dev/null

                exec test -f ${PGDATA}/PG_VERSION
            fi
}

postgres_daemon()
{
                @/usr/bin/pg_ctl@ -p@/usr/bin/postmaster@ -D"${PGDATA}" -s -l"${PGLOG}" -o"${PGOPTS}" start
}
#endd
