# Making this a need, rather than a use.  Shouldn't break anything, if the nodes exist, they won't be re-made

setup()
{
	ireg service daemon/vmware/vmnet/prepare && {
		iset need = system/bootmisc system/modules/vmnet
		iexec start = prepare
	}

	ireg daemon daemon/vmware/vmnet && {
		iset need = system/bootmisc daemon/vmware/vmnet/prepare
		iset exec daemon = "@/opt/vmware/bin/vmnet-bridge@ /dev/vmnet0 eth0"
	}
}

prepare()
{
	for i in 0 1 2 3
	do
		if [ ! -e "/dev/vmnet${i}" ]
		then
			@mknod@ -m 600 "/dev/vmnet${i}" c 119 0
		fi
	done
	exit 0
}
