# SERVICE: daemon/udhcpc/*
# NAME:
# DESCRIPTION:
# WWW:

[ -f /etc/conf.d/net ] && . /etc/conf.d/net

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset use = system/modules system/coldplug
		iset pid_file = "/var/run/udhcpc-${NAME}.pid"
		iset respawn
		iset forks
		iexec daemon
	idone
}

daemon()
{
	eval opts=\"\$\{udhcpc_${NAME}\}\"
	h=`hostname`
	[ -n "${h}" -a ! "${h}" = "(none)" -a ! "${h}" = "localhost" ] &&
		echo "${opts}" | @grep@ -w -- '-h' || opts="${opts} --hostname=${h}"
	exec @udhcpc@ ${opts} --now --script=${INITNG_PLUGIN_DIR}/scripts/net/udhcpc-wrapper --pidfile=/var/run/udhcpc-${NAME}.pid --interface=${NAME}
}
