# NAME: Pump
# DESCRIPTION: DHCP/BOOTP client
# WWW: http://ftp.debian.org/debian/pool/main/p/pump/

source /etc/conf.d/net

setup()
{
	iregister service

	iset need = "system/bootmisc"

	iset exec start = pump_any_start

	idone
}

pump_any_start()
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
	exec stop = @/sbin/pump@ --release -i ${NAME};
}
