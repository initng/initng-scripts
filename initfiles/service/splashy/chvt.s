# SERVICE: service/splashy/chvt
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iexec start
	idone
}

start()
{
	x_vt=""
	for i in `@seq@ 0 10`; do
		x_vt=`ps -C X -o args= | @sed@ 's/.* vt\([0-9]*\).*/\1/g'`
		[ ! -z "${x_vt}" ] && break
		sleep .2
	done
	[ "${x_vt}" -gt 0 ] && exit 0
	exec @/usr/bin/chvt@ ${x_vt}
}
