# SERVICE: daemon/acpid
# NAME: acpid
# DESCRIPTION: Advanced Configuration and Power Interface daemon
# WWW: http://acpid.sourceforge.net

#ifd debian
[ -f /etc/default/acpid ] && . /etc/default/acpid
#endd

setup() {
	iregister daemon
		iset need = system/bootmisc daemon/acpid/modules
		iset use = system/discover system/coldplug
		iset exec daemon = "@/usr/sbin/acpid@ -f -c /etc/acpi/events ${OPTIONS}"
	idone
}
