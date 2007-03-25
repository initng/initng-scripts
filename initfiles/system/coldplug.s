# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister -s "system/coldplug/pci" service
	iregister -s "system/coldplug/usb" service
	iregister -s "system/coldplug/scsi" service
	iregister -s "system/coldplug/input" service
	iregister -s "system/coldplug/ide" service
	iregister -s "system/coldplug/isapnp" service
#ifd unknown_system
	iregister -s "system/coldplug" service
#elsed
	iregister -s "system/coldplug" service
#endd

	iset -s "system/coldplug/pci" need = "system/initial"
	iset -s "system/coldplug/pci" use = "system/modules/depmod system/modules"
	iset -s "system/coldplug/pci" syncron = coldplug
	iset -s "system/coldplug/usb" need = "system/coldplug/pci system/initial"
	iset -s "system/coldplug/usb" use = "system/modules/depmod system/modules"
	iset -s "system/coldplug/usb" syncron = coldplug
	iset -s "system/coldplug/scsi" need = "system/initial system/coldplug/pci"
	iset -s "system/coldplug/scsi" use = "system/modules/depmod system/modules"
	iset -s "system/coldplug/scsi" syncron = coldplug
	iset -s "system/coldplug/input" need = "system/initial system/coldplug/pci"
	iset -s "system/coldplug/input" use = "system/modules/depmod system/modules system/coldplug/isapnp"
	iset -s "system/coldplug/input" syncron = coldplug
	iset -s "system/coldplug/ide" need = "system/initial system/coldplug/pci"
	iset -s "system/coldplug/ide" use = "system/modules/depmod system/modules"
	iset -s "system/coldplug/ide" syncron = coldplug
	iset -s "system/coldplug/isapnp" need = "system/initial"
	iset -s "system/coldplug/isapnp" use = "system/modules/depmod system/modules"
	iset -s "system/coldplug/isapnp" syncron = coldplug
#ifd unknown_system
#elsed
#endd
#ifd gentoo pingwinek
	iset -s "system/coldplug" need = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/input"
	iset -s "system/coldplug" also_stop = system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/input
#elsed
	iset -s "system/coldplug" need = "system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/isapnp system/coldplug/input system/coldplug/ide system/coldplug/scsi"
	iset -s "system/coldplug" also_stop = system/bootmisc system/coldplug/pci system/coldplug/usb system/coldplug/isapnp system/coldplug/input system/coldplug/ide system/coldplug/scsi
#endd
	iset -s "system/coldplug" use = "system/modules/depmod system/modules"

	iexec -s "system/coldplug/pci" start = "/etc/hotplug/${NAME}.rc start"
	iexec -s "system/coldplug/pci" stop = "/etc/hotplug/${NAME}.rc stop"
	iexec -s "system/coldplug/usb" start = "/etc/hotplug/${NAME}.rc start"
	iexec -s "system/coldplug/usb" stop = "/etc/hotplug/${NAME}.rc stop"
	iexec -s "system/coldplug/scsi" start = "/etc/hotplug/${NAME}.rc start"
	iexec -s "system/coldplug/scsi" stop = "/etc/hotplug/${NAME}.rc stop"
	iexec -s "system/coldplug/input" start = "/etc/hotplug/${NAME}.rc start"
	iexec -s "system/coldplug/input" stop = "/etc/hotplug/${NAME}.rc stop"
	iexec -s "system/coldplug/ide" start = "/etc/hotplug/${NAME}.rc start"
	iexec -s "system/coldplug/ide" stop = "/etc/hotplug/${NAME}.rc stop"
	iexec -s "system/coldplug/isapnp" start = "/etc/hotplug/${NAME}.rc start"
	iexec -s "system/coldplug/isapnp" stop = "/etc/hotplug/${NAME}.rc stop"
#ifd unknown_system
	iexec -s "system/coldplug" start = coldplug_start
#endd

	idone -s "system/coldplug/pci"
	idone -s "system/coldplug/usb"
	idone -s "system/coldplug/scsi"
	idone -s "system/coldplug/input"
	idone -s "system/coldplug/ide"
	idone -s "system/coldplug/isapnp"
#ifd unknown_system
	idone -s "system/coldplug"
#elsed
	idone -s "system/coldplug"
#endd
}

#ifd unknown_system
coldplug_start()
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
