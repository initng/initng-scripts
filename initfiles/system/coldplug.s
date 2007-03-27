# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s "system/coldplug/pci" service
	iset      -s "system/coldplug/pci" need = "system/initial"
	iset      -s "system/coldplug/pci" use = "system/modules/depmod system/modules"
	iset      -s "system/coldplug/pci" syncron = coldplug
	iset      -s "system/coldplug/pci" exec start = "/etc/hotplug/pci.rc start"
	iset      -s "system/coldplug/pci" exec stop = "/etc/hotplug/pci.rc stop"
	idone     -s "system/coldplug/pci"

	iregister -s "system/coldplug/usb" service
	iset      -s "system/coldplug/usb" need = "system/coldplug/pci system/initial"
	iset      -s "system/coldplug/usb" use = "system/modules/depmod system/modules"
	iset      -s "system/coldplug/usb" syncron = coldplug
	iset      -s "system/coldplug/usb" exec start = "/etc/hotplug/usb.rc start"
	iset      -s "system/coldplug/usb" exec stop = "/etc/hotplug/usb.rc stop"
	idone     -s "system/coldplug/usb"

	iregister -s "system/coldplug/scsi" service
	iset      -s "system/coldplug/scsi" need = "system/initial system/coldplug/pci"
	iset      -s "system/coldplug/scsi" use = "system/modules/depmod system/modules"
	iset      -s "system/coldplug/scsi" syncron = coldplug
	iset      -s "system/coldplug/scsi" exec start = "/etc/hotplug/scsi.rc start"
	iset      -s "system/coldplug/scsi" exec stop = "/etc/hotplug/scsi.rc stop"
	idone     -s "system/coldplug/scsi"

	iregister -s "system/coldplug/input" service
	iset      -s "system/coldplug/input" need = "system/initial system/coldplug/pci"
	iset      -s "system/coldplug/input" use = "system/modules/depmod system/modules system/coldplug/isapnp"
	iset      -s "system/coldplug/input" syncron = coldplug
	iset      -s "system/coldplug/input" exec start = "/etc/hotplug/input.rc start"
	iset      -s "system/coldplug/input" exec stop = "/etc/hotplug/input.rc stop"
	idone     -s "system/coldplug/input"

	iregister -s "system/coldplug/ide" service
	iset      -s "system/coldplug/ide" need = "system/initial system/coldplug/pci"
	iset      -s "system/coldplug/ide" use = "system/modules/depmod system/modules"
	iset      -s "system/coldplug/ide" syncron = coldplug
	iset      -s "system/coldplug/ide" exec start = "/etc/hotplug/ide.rc start"
	iset      -s "system/coldplug/ide" exec stop = "/etc/hotplug/ide.rc stop"
	idone     -s "system/coldplug/ide"

	iregister -s "system/coldplug/isapnp" service
	iset      -s "system/coldplug/isapnp" need = "system/initial"
	iset      -s "system/coldplug/isapnp" use = "system/modules/depmod system/modules"
	iset      -s "system/coldplug/isapnp" syncron = coldplug
	iset      -s "system/coldplug/isapnp" exec start = "/etc/hotplug/isapnp.rc start"
	iset      -s "system/coldplug/isapnp" exec stop = "/etc/hotplug/isapnp.rc stop"
	idone     -s "system/coldplug/isapnp"


	iregister -s "system/coldplug" service
#ifd gentoo pingwinek
	iset      -s "system/coldplug" need = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/input"
	iset      -s "system/coldplug" also_stop = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/input"
#elsed
	iset      -s "system/coldplug" need = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/isapnp system/coldplug/input system/coldplug/ide system/coldplug/scsi"
	iset      -s "system/coldplug" also_stop = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/isapnp system/coldplug/input system/coldplug/ide system/coldplug/scsi"
#endd
	iset      -s "system/coldplug" use = "system/modules/depmod system/modules"
#ifd unknown_system
	iexec     -s "system/coldplug" start
#endd
	idone     -s "system/coldplug"
}

#ifd unknown_system
start()
{
	# needed to make /dev/input/mice for X
	if [ -e /sys/class/input/mice/dev ]
	then
		@mkdir@ -p /dev/input
		@mknod@ /dev/input/mice c 13 63 >/dev/null 2>&1
	fi
	exit 0
}
#endd
