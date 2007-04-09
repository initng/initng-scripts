# NAME:
# DESCRIPTION:
# WWW:

#ifd debian ubuntu
. /etc/default/gdm
#endd

setup()
{
	ireg service daemon/instant-gdm/dev
	iset need = system/bootmisc
	iexec start = dev_start
	idone

	ireg daemon daemon/instant-gdm
	iset need = system/bootmisc
	iset use = daemon/instant-gdm/dev service/xorgconf \
	           system/modules/mousedev system/modules/fglrx \
	           system/modules/nvidia
	iset nice = -4
	iset exec daemon = "@/usr/sbin/gdm@ -nodaemon"
	idone
}

dev_start()
{
	[ -e /sys/class/input/mice/dev ] || exit 0
	@mkdir@ -p /dev/input
	@mknod@ /dev/input/mice c 13 63 >/dev/null 2>&1
}
