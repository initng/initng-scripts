# SERVICE: system/initial/filldev
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/initial/mountvirtfs
		iset use = system/udev/mountdev
		iset critical
		iexec start
	idone
}

start()
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
