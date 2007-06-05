# SERVICE: system/hostname
# NAME: hostname
# DESCRIPTION: Sets the system hostname

#ifd debian
#elsed
HOSTNAME="localhost"
#ifd fedora mandriva
. /etc/sysconfig/network
#elsed
[ -f /etc/conf.d/hostname ] && . /etc/conf.d/hostname
#endd
#endd

setup()
{
	iregister service
		iset need = system/initial
		iexec start
	idone
}

#ifd debian
start()
{
	[ -f /etc/hostname ] && HOSTNAME="$(</etc/hostname)"

	if [ -z "${HOSTNAME}" ]; then
		# Keep current name if /etc/hostname is missing.
		# or set it to 'localhost' if no setting was found
		[ -z "$(hostname)" ] && hostname localhost
		exit 0
	fi

	echo "Setting hostname to '${HOSTNAME}'"
	hostname "${HOSTNAME}"
}
#elsed

start()
{
	# If the hostname is already set via the kernel, and /etc/hostname
	# isn't setup, then we shouldn't go reseting the configuration #38172.
	if [ -n "${HOSTNAME}" ]; then
		@/bin/true@
#ifd gentoo fedora
	elif [ -f /etc/hostname ]; then
		HOSTNAME=$(@cat@ /etc/hostname)
#endd
	elif host=$(@/bin/hostname@)
	     [ -z "${host}" -o "${host}" = '(none)' ]; then
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
	[ ! -L /etc/env.d/01hostname ] &&
		@rm@ /etc/env.d/01hostname >/dev/null 2>&1 &&
		echo 'HOSTNAME="'"$(@/bin/hostname@)"'"' 2>/dev/null >/etc/env.d/01hostname
	exit ${ret}
#elsed
	exec @/bin/hostname@ "${HOSTNAME}"
#endd
}
#endd
