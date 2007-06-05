# SERVICE: system/udev/mountdev
# NAME: udev
# DESCRIPTION: The Linux Userspace Device filesystem
# WWW: http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html

setup()
{
	iregister service
		iset critical
		iset need = system/initial/mountvirtfs
		iexec start
	idone
}

start()
{
	error() {
		echo "${*}" >&2
		exit 1
	}

	[ -e /proc/filesystems ] ||
		error "udev requires a mounted procfs, not started."

	@grep@ -q '[[:space:]]tmpfs$' /proc/filesystems || error "udev requires tmpfs support, not started."

	[ -d /sys/block ] ||
		error "udev requires a mounted sysfs, not started."

	# mount a tmpfs over /dev, if somebody did not already do it
	@grep@ -Eq "^[^[:space:]]+[[:space:]]+/dev[[:space:]]+tmpfs[[:space:]]+" /proc/mounts && exit 0

#ifd debian ubuntu
	# /dev/.static/dev is used by MAKEDEV to access the real /dev directory.
	# /etc/udev is recycled as a temporary mount point because it's the only
	# directory which is guaranteed to be available.
	@mount@ -n --bind /dev /etc/udev
#endd
	if ! @mount@ -n -o size=$tmpfs_size,mode=0755 -t tmpfs udev /dev; then
		@umount@ -n /etc/udev
		error "udev in /dev his own filesystem (tmpfs), not started."
	fi
#ifd debian ubuntu
	@mkdir@ -p /dev/.static/dev
	@chmod@ 700 /dev/.static/
	@mount@ -n --move /etc/udev /dev/.static/dev
#endd

	# Make some default static ones, so we are sure they will exist.
	@mknod@ -m0666 /dev/null c 1 3
	@mknod@ -m0666 /dev/zero c 1 5
	@mknod@ /dev/console c 5 1

	# Send SIGHUP to initng, will reopen /dev/initctl and /dev/initng.
	# we can't assume that initng has pid 1, e.g. when booting from initrd
	@/bin/kill@ -HUP $INITNG_PID

	exit 0
}
