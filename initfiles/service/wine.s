# SERVICE: service/wine
# NAME: wine
# DESCRIPTION: Wine Windows emulator
# WWW: http://www.winehq.com

setup()
{
	iregister service
		iset need = system/bootmisc
		iexec start
		iexec stop
	idone
}

start()
{
	if [ -ne /proc/sys/fs/binfmt_misc/windows ]; then
		mount -t binfmt_misc none /proc/sys/fs/binfmt_misc &>/dev/null
		echo ':windows:M::MZ::/usr/bin/wine:' >/proc/sys/fs/binfmt_misc/register || :
		echo ':windowsPE:M::PE::/usr/bin/wine:' >/proc/sys/fs/binfmt_misc/register || :
	fi
}

stop()
{
	echo "-1" >/proc/sys/fs/binfmt_misc/windows || :
	echo "-1" >/proc/sys/fs/binfmt_misc/windowsPE || :
}
