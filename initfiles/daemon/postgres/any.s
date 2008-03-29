# SERVICE: daemon/postgres/*
# NAME: PostgreSQL
# DESCRIPTION: Relational database
# WWW: http://www.postgresql.org/

#ifd debian
. /usr/share/postgresql-common/init.d-functions

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset provide = virtual/postgres
		iset suid = postgres
		iset sgid = postgres
		iset pid_file = "/var/run/postgresql/${NAME}-main.pid"
		iset forks
		iexec daemon
		iexec kill
	idone
}

daemon() {
	start ${NAME}
}

kill() {
	stop ${NAME}
}
#endd
