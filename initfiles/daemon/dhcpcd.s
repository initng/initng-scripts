# NAME: 
# DESCRIPTION: 
# WWW: 

source /etc/conf.d/net

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "system/modules system/coldplug"
#ifd arch
	iset pid_file = "/etc/dhcpc/dhcpcd-${NAME}.pid"
#elsed
	iset pid_file = "/var/run/dhcpcd-${NAME}.pid"
#endd
	iset forks
	iset respawn
	iset daemon_stops_badly

	iset exec daemon = dhcpcd_any_daemon

	idone
}

dhcpcd_any_daemon()
{
		eval opts=\"\$\{dhcpcd_${NAME}\}\"
#ifd gentoo
		# Gentoo dhcpcd supports the -o option which stops the
		# interface from being taken down when dhcpcd exits
		# This is needed if something like ifplugd or wpa_supplicant
		# is controlling dhcp on the interface
		/sbin/dhcpcd -h 2>&1 | @grep@ -q "dkno" && opts="${opts} -o"
#endd
		eval d=\"\$\{dhcp_${NAME}\}\"
		[ "${d}" = "" ] && d="${dhcp}"

		for o in ${d}
		do
			case ${o} in
				nodns) opts="${opts} -R" ;;
				nontp) opts="${opts} -N" ;;
				nonis) opts="${opts} -Y" ;;
				nohostname) opts="${opts} -h" ;;
			esac
		done

		# Bad things happen if we get an infinite lease,
		# so try and make sure we don't
		echo "${opts}" | @grep@ -w -- '-l' > /dev/null || opts="${opts} -l 86400"

		h=`hostname`
		if [ -n "${h}" -a ! "${h}" = "(none)" -a ! "${h}" = "localhost" ]
		then
			echo "${opts}" | @grep@ -w -- '-h' || opts="${opts} -h ${h}"
		fi
		exec @/sbin/dhcpcd@ ${opts} ${NAME}
}
