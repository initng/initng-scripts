# NAME: Pump
# DESCRIPTION: DHCP/BOOTP client
# WWW: http://ftp.debian.org/debian/pool/main/p/pump/

[ -f /etc/conf.d/net ] && . /etc/conf.d/net

setup()
{
	ireg service #daemon/pump/*
	iset need = system/bootmisc
	iexec start
	iset exec stop = "@/sbin/pump@ --release -i ${NAME}"
	idone
}

start()
{
	eval opts=\${pump_${NAME}}
	eval d=\${dhcp_${NAME}}
	[ "${d}" = "" ] && d="${dhcp}"

	for o in ${d}
	do
		case "${o}" in
			"nodns") opts="${opts} --no-dns"
		esac
	done

	h=`hostname`
	if [ -n "${h}" -a ! "${h}" = "(none)" -a ! "${h}" = "localhost" ]
	then
		echo "${opts}" | @grep@ -w -- '-h' || opts="${opts} -h ${h}"
	fi

	exec @/sbin/pump@ ${opts} -i ${NAME}
}
