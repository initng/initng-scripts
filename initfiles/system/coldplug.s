# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/coldplug/pci
	iset need = system/initial
	iset use = system/modules/depmod system/modules
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/pci.rc start"
	iset exec stop = "/etc/hotplug/pci.rc stop"
	idone

	ireg service system/coldplug/usb
	iset need = system/coldplug/pci system/initial
	iset use = system/modules/depmod system/modules
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/usb.rc start"
	iset exec stop = "/etc/hotplug/usb.rc stop"
	idone

	ireg service system/coldplug/scsi
	iset need = system/initial system/coldplug/pci
	iset use = system/modules/depmod system/modules
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/scsi.rc start"
	iset exec stop = "/etc/hotplug/scsi.rc stop"
	idone

	ireg service system/coldplug/input
	iset need = system/initial system/coldplug/pci
	iset use = system/modules/depmod system/modules system/coldplug/isapnp
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/input.rc start"
	iset exec stop = "/etc/hotplug/input.rc stop"
	idone

	ireg service system/coldplug/ide
	iset need = system/initial system/coldplug/pci
	iset use = system/modules/depmod system/modules
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/ide.rc start"
	iset exec stop = "/etc/hotplug/ide.rc stop"
	idone

	ireg service system/coldplug/isapnp
	iset need = system/initial
	iset use = system/modules/depmod system/modules
	iset syncron = coldplug
	iset exec start = "/etc/hotplug/isapnp.rc start"
	iset exec stop = "/etc/hotplug/isapnp.rc stop"
	idone

#ifd unknown_system
	ireg service system/coldplug
#elsed
	ireg virtual system/coldplug
#endd
	iset need = system/bootmisc system/coldplug/{pci,usb,input}
	iset also_stop = system/bootmisc system/coldplug/{pci,usb,input}
#ifd gentoo pingwinek lfs
#elsed
	iset need = system/coldplug/{isapnp,ide,scsi}
	iset also_stop = system/coldplug/{isapnp,ide,scsi}
#endd
	iset use = system/modules
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
