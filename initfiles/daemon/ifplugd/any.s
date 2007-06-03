# SERVICE: daemon/ifplugd/*
# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
[ -f /etc/default/ifplugd ] && . /etc/default/ifplugd
#elsed gentoo
[ -f /etc/conf.d/ifplugd ] && . /etc/conf.d/ifplugd
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset use = system/modules system/coldplug system/ifrename
		iset stdall = /dev/null
#ifd debian
		iexec daemon
#elsed
		iset exec daemon = "@/usr/sbin/ifplugd@ --no-daemon -i ${NAME}"
#endd
	idone
}

#ifd debian
daemon()
{
	IF1=`echo ${NAME} | @sed@ "s/-/_/"`
	A=`eval echo \$\{ARGS_${IF1}\}`
	[ -z "${A}" ] && A="${ARGS}"

	exec @/usr/sbin/ifplugd@ --no-daemon -i ${NAME} ${A}
}
#endd
