#!/sbin/runiscript

setup()
{
	# Register all services.
    iregister -s initial/mountvirtfs service
	iregister -s initial/filldev service
	iregister -s initial/loglevel service
	iregister virtual

	# Mark them critical
	iset -s initial/mountvirtfs critical
	iset -s initial/filldev critical
	
	# Set up deps
	iset -s initial/filldev need = initial/mountvirtfs
	iset -s initial/filldev use = udev/mountdev
	iset need = "initial/loglevel initial/mountvirtfs initial/filldev"
	iset use = "selinux/dev udev"
	
 	# Set run locations in this script
	iexec -s initial/mountvirtfs start = mountvirtfs_start
	iexec -s initial/filldev start = filldev_start

	# Local executes, not needing scripts
	iset -s initial/loglevel exec start = "/bin/dmesg -n 1"
	iset -s initial/loglevel exec stop = "/bin/dmesg -n 2"
	
	# Tell initng this service is done parsing.
    idone -s initial/mountvirtfs
	idone -s initial/filldev
	idone -s initial/loglevel
	idone
}

mountvirtfs_start()
{
	# test, if all necessary directories exist.
	for dir in /proc /sys
	do
		if [ ! -d ${dir} ] # no?
		then
			echo "The dir \"${dir}\" is missing, cant mount it!" >&2
			echo "Please sulogin, remount rw and create them." >&2
			exit 1 # It cant work. Critical!
		fi
	done

	@mount@ -n -t proc proc /proc &
	@mount@ -n -t sysfs sys /sys &

	wait
	exit 0
}

filldev_start()
{
	echo "Mounting devpts at /dev/pts ..."
	@/bin/mkdir@ -p /dev/pts && @/bin/mount@ -n -t devpts -o gid=5,mode=0620 none /dev/pts &

	echo "Mounting devshm at /dev/shm ..."
	@/bin/mkdir@ -p /dev/shm && @/bin/mount@ -n -t tmpfs none /dev/shm &

	# who needs this? only user, who needs this.
	# so i think, we should make this link, if somebody needs this.
	[ ! -e /dev/MAKEDEV -a /sbin/MAKEDEV ] && \
		@/bin/ln@ -fs /sbin/MAKEDEV /dev/MAKEDEV &

	wait
	exit 0
}
