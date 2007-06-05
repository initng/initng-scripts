# SERVICE: system/pcmcia
# NAME:
# DESCRIPTION:
# WWW:

[ -f /etc/conf.d/pcmcia ] && . /etc/conf.d/pcmcia

setup()
{
	iregister service
		iset need = system/bootmisc
		iexec start
	idone
}

start()
{
	cleanup() {
		while read SN CLASS MOD INST DEV EXTRA; do
			[ "x${SN}" != "xSocket" ] &&
				/etc/pcmcia/${CLASS} stop ${DEV} 2> /dev/null
		done
	}

	umask 022

	# Scheme is set for the /etc/pcmcia/shared script
	echo ${SCHEME} > /var/run/pcmcia-scheme

	# clean up any old interfaces
	[ -r /var/run/stab ] && @cat@ /var/run/stab | cleanup

	# if /var/lib/pcmcia exists (and sometimes it gets created accidentally
	# if you run pcmcia-cs apps w/out the proper flags), then it will really
	# confuse the process
	[ -d /var/lib/pcmcia ] && @rm@ -rf /var/lib/pcmcia

	if [ -e /proc/bus/pccard ]; then
		echo "PCMCIA support detected ..."
	else
		echo "Trying to load pcmcia modules, should have been loaded with coldplug/pci or static-modules ..."
		@/sbin/modprobe@ pcmcia_core ${CORE_OPTS}
		if [ -n "${PCIC}" ]; then
			if ! @/sbin/modprobe@ ${PCIC} ${PCIC_OPTS}; then
				echo "'@/sbin/modprobe@ ${PCIC}' failed"
				echo "Trying alternative PCIC driver: ${PCIC_ALT}"
				@/sbin/modprobe@ ${PCIC_ALT} ${PCIC_ALT_OPTS}
			fi
		fi
		@/sbin/modprobe@ ds
	fi
}
