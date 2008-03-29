# SERVICE: daemon/vmware/vmnet/prepare
# NAME:
# DESCRIPTION:
# WWW:

# Making this a need, rather than a use.  Shouldn't break anything, if the
# nodes exist, they won't be re-made

setup() {
	iregister service
		iset need = system/bootmisc system/modules/vmnet
		iexec start
	idone
}

start() {
	for i in 0 1 2 3; do
		[ ! -e "/dev/vmnet${i}" ] &&
			@mknod@ -m 600 "/dev/vmnet${i}" c 119 0
	done
	exit 0
}
