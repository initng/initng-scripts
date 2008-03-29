# SERVICE: system/coldplug
# NAME:
# DESCRIPTION:
# WWW:

setup() {
#ifd unknown_system
	iregister service
#elsed
	iregister virtual
#endd
		iset need = system/bootmisc system/coldplug/pci \
			    system/coldplug/usb system/coldplug/input
		iset also_stop = system/bootmisc system/coldplug/pci \
				 system/coldplug/usb system/coldplug/input
#ifd gentoo pingwinek lfs
#elsed
		iset need = system/coldplug/isapnp system/coldplug/ide \
			    system/coldplug/scsi
		iset also_stop = system/coldplug/isapnp system/coldplug/ide \
				 system/coldplug/scsi
#endd
		iset use = system/modules
#ifd unknown_system
		iexec start
#endd
	idone
}

#ifd unknown_system
start() {
	# needed to make /dev/input/mice for X
	if [ -e /sys/class/input/mice/dev ]; then
		@mkdir@ -p /dev/input
		@mknod@ /dev/input/mice c 13 63 >/dev/null 2>&1
	fi
	exit 0
}
#endd
