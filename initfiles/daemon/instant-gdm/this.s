# SERVICE: daemon/instant-gdm
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset use = daemon/instant-gdm/dev service/xorgconf \
		           system/modules/mousedev system/modules/fglrx \
		           system/modules/nvidia
		iset nice = -4
		iset exec daemon = "@/usr/sbin/gdm@ -nodaemon"
	idone
}
