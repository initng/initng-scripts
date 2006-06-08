#!/sbin/runiscript

setup()
{
    iregister service
    iset need = initial
	iexec start
    idone
}

#ifd debian
start()
{
	[ -f /etc/hostname ] && HOSTNAME="$(cat /etc/hostname)"

	# Keep current name if /etc/hostname is missing.
	[ -z "$HOSTNAME" ] && HOSTNAME="$(hostname)"

	# And set it to 'localhost' if no setting was found
	[ -z "$HOSTNAME" ] && HOSTNAME=localhost

	echo "Setting hostname to '$HOSTNAME'"
	hostname "$HOSTNAME"
}

#elsed



HOSTNAME=localhost;
#ifd fedora
source /etc/sysconfig/network;
#elsed
source /etc/conf.d/hostname;
#endd

start()
{
		# If the hostname is already set via the kernel, and /etc/hostname
		# isn't setup, then we shouldn't go reseting the configuration #38172.
		if [ "${HOSTNAME}" ]
		then
			@/bin/true@

#ifd gentoo fedora
		elif [ -f /etc/hostname ]
		then
			HOSTNAME=$(@cat@ /etc/hostname)
#endd


		elif host=$(@/bin/hostname@)
			[ -z "${host}" -o "${host}" = '(none)' ]
		then
			HOSTNAME=${host}
		else
			HOSTNAME='localhost'
		fi



#ifd gentoo
		@/bin/hostname@ "${HOSTNAME}"
		ret=${?}
		# /etc/env.d/01hostname in gentoo is setted by init-script.
		# i say, you should set a link:
		#         /etc/conf.d/hostname <- /etc/env.d/01hostname
		[ ! -L /etc/env.d/01hostname ] && \
			@rm@ /etc/env.d/01hostname 2>&1 >/dev/null && \
			echo 'HOSTNAME="'"$(@/bin/hostname@)"'"' 2>/dev/null >/etc/env.d/01hostname
		exit ${ret}
#elsed
		exec @/bin/hostname@ "${HOSTNAME}"
#endd
}


#endd

