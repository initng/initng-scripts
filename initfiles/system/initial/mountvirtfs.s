# SERVICE: system/initial/mountvirtfs
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iexec start
		iset critical
	idone
}

start()
{
	# test, if all necessary directories exist.
	if [ ! -d /proc -o ! -d /sys ]; then
		echo "The /sys or /proc is missing, can't mount it!" >&2
		echo "Please sulogin, remount rw and create them." >&2
		exit 1 # It cant work. Critical!
	fi

	mount -n -t proc proc /proc &
	mount -n -t sysfs sys /sys &

	wait
	exit 0
}
