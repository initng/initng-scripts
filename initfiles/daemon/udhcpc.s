# NAME:
# DESCRIPTION:
# WWW:

[ -f /etc/conf.d/net ] && . /etc/conf.d/net

setup()
{
	[ "${SERVICE}" = daemon/udhcpc ] && return 1

	# daemon/udhcpc/*
	ireg daemon && {
		iset need = system/bootmisc
		iset use = system/modules system/coldplug
		iset pid_file = "/var/run/udhcpc-${NAME}.pid"
		iset respawn
		iset forks
		iexec daemon
	}
}

daemon()
{
	eval opts=\"\$\{udhcpc_${NAME}\}\"
	h=`hostname`
	if [ -n "${h}" -a ! "${h}" = "(none)" -a ! "${h}" = "localhost" ]
	then
		echo "${opts}" | @grep@ -w -- '-h' || opts="${opts} --hostname=${h}"
	fi
	exec @udhcpc@ ${opts} --now --script=${INITNG_PLUGIN_DIR}/scripts/net/udhcpc-wrapper --pidfile=/var/run/udhcpc-${NAME}.pid --interface=${NAME}
}
