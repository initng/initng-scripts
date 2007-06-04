# SERVICE: service/readahead/watcher-desktop
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/mountfs/essential
		iset also_start = service/readahead/stopper
		iset forks
		iexec daemon
	idone
}

daemon()
{
	# Move away the old pid created by service/readahead/watcher
	mv /var/run/readahead-watch.pid /var/run/readahead-watch-boot.pid

	# Add /usr to dirs, if that is a mountpoint
	mountpoint -q /usr &&
		dirs="$dirs /usr"

	# Add /var to dirs, if that is a mountpoint
	mountpoint -q /var &&
		dirs="$dirs /var"

	exec @/usr/sbin/readahead-watch@ -o /etc/readahead/desktop $dirs

	# Never get here
	exit 1
}
