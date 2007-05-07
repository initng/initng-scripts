# NAME: wine
# DESCRIPTION: Wine Windows emulator
# WWW: http://www.winehq.com

setup()
{
	ireg service service/wine && {
		iset need = system/bootmisc
		iexec start = wine_start
		iexec stop = wine_stop
		return 0
	}
}

wine_start()
{
	if [ -ne /proc/sys/fs/binfmt_misc/windows ]
	then
		mount -t binfmt_misc none /proc/sys/fs/binfmt_misc &>/dev/null
		echo ':windows:M::MZ::/usr/bin/wine:' >/proc/sys/fs/binfmt_misc/register || :
		echo ':windowsPE:M::PE::/usr/bin/wine:' >/proc/sys/fs/binfmt_misc/register || :
	fi
}

wine_stop()
{
	echo "-1" >/proc/sys/fs/binfmt_misc/windows || :
	echo "-1" >/proc/sys/fs/binfmt_misc/windowsPE || :
}

