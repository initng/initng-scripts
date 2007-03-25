# NAME:
# DESCRIPTION:
# WWW:

#ifd debian ubuntu
source /etc/default/gdm
#endd

setup()
{
	iregister -s "daemon/instant-gdm/dev" service
	iregister -s "daemon/instant-gdm" daemon

	iset -s "daemon/instant-gdm/dev" need = "system/bootmisc"
	iset -s "daemon/instant-gdm" need = "system/bootmisc"
	iset -s "daemon/instant-gdm" use = "daemon/instant-gdm/dev service/xorgconf system/modules/mousedev system/modules/fglrx system/modules/nvidia"
	iset -s "daemon/instant-gdm" nice = -4

	iexec -s "daemon/instant-gdm/dev" start = dev_start
	iexec -s "daemon/instant-gdm" daemon = "@/usr/sbin/gdm@ -nodaemon"

	idone -s "daemon/instant-gdm/dev"
	idone -s "daemon/instant-gdm"
}

dev_start()
{
		if [ -e /sys/class/input/mice/dev ]
		then
			@mkdir@ -p /dev/input
			@mknod@ /dev/input/mice c 13 63 >/dev/null 2>&1
		fi
}
