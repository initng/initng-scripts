# SERVICE: service/xorgconf
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc
		iexec start
	idone
}

start()
{
#ifd pingwinek
        if [ ! -f /etc/X11/xorg.conf ]; then
		driver=`@makexorgconf@ 2>/dev/null`
		echo "The X graphics driver is '${driver}'"
	fi
#elsed
	[ -f /etc/X11/xorg.conf ] || @Xorg@ -configure
	@cp@ /root/xorg.conf.new /etc/X11/xorg.conf
#endd
}
