# NAME:
# DESCRIPTION:
# WWW:

#ifd fedora lfs mandriva
source /etc/sysconfig/915resolution
#elsed
source /etc/default/915resolution
#endd

setup()
{
	ireg service service/915resolution
	iset need = system/mountfs/essential
	iexec start
	idone
}

start()
{
	[ -x @915resolution@ ] || exit 1

#ifd fedora
	for mode in "${VBMODES[@]}"; do
		@915resolution@ $mode >/dev/null
	done
#elsed
	if ! [ "${MODE}" -a "${XRESO}" -a "${YRESO}" ]
	then
	   echo "*** Your 915resolution hasn't been configured! ***"
	   echo "Please read /usr/share/doc/915resolution/README.Debian and define"
	   echo "MODE, XRESO, and YRESO."
	   exit 0
	fi
	exec @915resolution@ ${MODE} ${XRESO} ${YRESO} ${BIT}
#endd
}
