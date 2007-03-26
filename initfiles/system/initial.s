# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s system/initial/mountvirtfs service
	iexec -s system/initial/mountvirtfs start = mountvirtfs_start
	iset  -s system/initial/mountvirtfs critical
	idone -s system/initial/mountvirtfs

	iregister -s system/initial/filldev service
	iset  -s system/initial/filldev need = "system/initial/mountvirtfs"
	iset  -s system/initial/filldev use = "system/udev/mountdev"
	iset  -s system/initial/filldev critical
	iexec -s system/initial/filldev start = filldev_start
	idone -s system/initial/filldev

	iregister -s system/initial/loglevel service
	iexec -s system/initial/loglevel start = "@/sbin/dmesg@ -n 1"
	iexec -s system/initial/loglevel stop = "@/sbin/dmesg@ -n 2"
	idone -s system/initial/loglevel

	iregister -s system/initial virtual
	iset  -s system/initial critical
	iset  -s system/initial need = "system/initial/loglevel system/initial/mountvirtfs system/initial/filldev"
	iset  -s system/initial use = "system/selinux/dev system/udev"
	idone -s system/initial
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
