# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="system/coldplug/pci"
	iregister service
	iset need = "system/initial"
	iset use = "system/modules/depmod system/modules"
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/pci.rc start"
	iset exec stop = "/etc/hotplug/pci.rc stop"
	idone

 	export SERVICE="system/coldplug/usb"
	iregister service
	iset need = "system/coldplug/pci system/initial"
	iset use = "system/modules/depmod system/modules"
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/usb.rc start"
	iset exec stop = "/etc/hotplug/usb.rc stop"
	idone

	export SERVICE="system/coldplug/scsi"
	iregister service
	iset need = "system/initial system/coldplug/pci"
	iset use = "system/modules/depmod system/modules"
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/scsi.rc start"
	iset exec stop = "/etc/hotplug/scsi.rc stop"
	idone

	export SERVICE="system/coldplug/input"
	iregister service
	iset need = "system/initial system/coldplug/pci"
	iset use = "system/modules/depmod system/modules system/coldplug/isapnp"
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/input.rc start"
	iset exec stop = "/etc/hotplug/input.rc stop"
	idone

	export SERVICE="system/coldplug/ide"
	iregister service
	iset need = "system/initial system/coldplug/pci"
	iset use = "system/modules/depmod system/modules"
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/ide.rc start"
	iset exec stop = "/etc/hotplug/ide.rc stop"
	idone

	export SERVICE="system/coldplug/isapnp"
	iregister service
	iset need = "system/initial"
	iset use = "system/modules/depmod system/modules"
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/isapnp.rc start"
	iset exec stop = "/etc/hotplug/isapnp.rc stop"
	idone

	export SERVICE="system/coldplug"
#ifd unknown_system
	iregister service
#elsed
	iregister virtual
#endd
#ifd gentoo pingwinek
	iset need = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/input"
	iset also_stop = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/input"
#elsed
	iset need = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/isapnp system/coldplug/input system/coldplug/ide system/coldplug/scsi"
	iset also_stop = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/isapnp system/coldplug/input system/coldplug/ide system/coldplug/scsi"
#endd
	iset use = "system/modules/depmod system/modules"
#ifd unknown_system
	iexec start
#endd
	idone
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
