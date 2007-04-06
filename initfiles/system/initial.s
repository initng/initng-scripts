# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/initial/mountvirtfs
	iexec start = mountvirtfs_start
	iset critical
	idone

	ireg service system/initial/filldev
	iset need = system/initial/mountvirtfs
	iset use = system/udev/mountdev
	iset critical
	iexec start = filldev_start
	idone

	ireg service system/initial/loglevel
	iset exec start = "@/sbin/dmesg@ -n 1"
	iset exec stop = "@/sbin/dmesg@ -n 2"
	idone

	ireg virtual system/initial
	iset critical
	iset need = system/initial/{loglevel,mountvirtfs,filldev}
	iset use = system/selinux/dev system/udev
	idone
}

mountvirtfs_start()
{
	# test, if all necessary directories exist.
	if [ ! -d /proc -o ! -d /sys ]
	then
		echo "The /sys or /proc is missing, can't mount it!" >&2
		echo "Please sulogin, remount rw and create them." >&2
		exit 1 # It can't work. Critical!
	fi

	mount -n -t proc proc /proc &
	mount -n -t sysfs sys /sys &

	wait
	exit 0
}

filldev_start()
{
	echo "Mounting devpts at /dev/pts ..."
	@/bin/mkdir@ -p /dev/pts &&
		@mount@ -n -t devpts -o gid=5,mode=0620 none /dev/pts &

	echo "Mounting devshm at /dev/shm ..."
	@/bin/mkdir@ -p /dev/shm &&
		@mount@ -n -t tmpfs none /dev/shm &

	wait
	exit 0
}
