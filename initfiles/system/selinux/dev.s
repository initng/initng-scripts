# SERVICE: system/selinux/dev
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial/mountvirtfs
		iexec start
	idone
}

start() {
	[ -x @/sbin/restorecon@ ] && @fgrep@ -q " /dev " /proc/mounts &&
		@/sbin/restorecon@ -R /dev 2>/dev/null
}
