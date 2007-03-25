# Making this a need, rather than a use.  Shouldn't break anything, if the nodes exist, they won't be re-made

setup()
{
	iregister -s "daemon/vmware/vmnet/prepare" service
	iregister -s "daemon/vmware/vmnet" daemon

	iset -s "daemon/vmware/vmnet/prepare" need = "system/bootmisc system/modules/vmnet"
	iset -s "daemon/vmware/vmnet" need = "system/bootmisc daemon/vmware/vmnet/prepare"

	iexec -s "daemon/vmware/vmnet/prepare" start = prepare_start
	iexec -s "daemon/vmware/vmnet" daemon = "@/opt/vmware/bin/vmnet-bridge@ /dev/vmnet0 eth0"

	idone -s "daemon/vmware/vmnet/prepare"
	idone -s "daemon/vmware/vmnet"
}

prepare_start()
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
