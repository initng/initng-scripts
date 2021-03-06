# SERVICE: system/usb
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/bootmisc
#ifd fedora
#elsed
		iset need = system/modules/usbcore
#endd
		iexec start
	idone
}

start() {
#ifd fedora
	# Make sure we insert usbcore if its a module
	if [ -f /proc/modules ]; then
		# >/dev/null to hide errors from non-USB users
		for i in `@grep@ "driver: .*-hcd" /etc/sysconfig/hwconf|cut -d" " -f2`; do
			@/sbin/modprobe@ ${i} >/dev/null 2>&1 &
		done
	fi
#endd
	# Check what USB fs the kernel support.  Currently
	# 2.5+ kernels, and later 2.4 kernels have 'usbfs',
	# while older kernels have 'usbdevfs'.
	usbfs=`@grep@ -Eow "usb(dev)?fs" /proc/filesystems`

	if [ -n "${usbfs}" -a -e /proc/bus/usb -a ! -e /proc/bus/usb/devices ]; then
		usbgid=`@awk@ -F: '/^usb:/{print $3; exit}' /etc/group`
		if [ -n "${usbgid}" ]; then
			@mount@ -t ${usbfs} usbfs /proc/bus/usb ${usbgid:+-o devmode=0664,devgid=${usbgid}} >/dev/null 2>&1 &
		else
			@mount@ -t ${usbfs} usbfs /proc/bus/usb >/dev/null 2>&1 &
		fi
	fi
	wait
}
