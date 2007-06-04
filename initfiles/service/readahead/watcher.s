# SERVICE: service/readahead/watcher
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/mountfs/essential
		iset also_start = service/readahead/stopper
		iset forks
		iset pid_file = "/var/run/readahead-watch.pid"
		iexec daemon
	idone
}

daemon()
{

	# If /usr or /var is mounted on another filesystem, make sure they will also be checked
	mountpoint -q /usr &&
		@/sbin/ngc@ --quiet --instant -u service/readahead/watcher-desktop
	mountpoint -q /var &&
		@/sbin/ngc@ --quiet --instant -u service/readahead/watcher-desktop

	# Okay, launch watcher.
	exec @/usr/sbin/readahead-watch@ -o /etc/readahead/boot

	exit 1
}
