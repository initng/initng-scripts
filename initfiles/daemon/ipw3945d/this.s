# SERVICE: daemon/ipw3945d
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister task
		iset need = daemon/ipw3945/real
		iset once
		iexec task
	idone
}

task()
{
	count=0
	while [ ! -d $(echo /sys/class/net/*/wireless | cut -f1 -d\ ) ]; do
		sleep 0.1
		count=$((count+1))
		[ $count -gt 100 ] && exit 1
	done
}
