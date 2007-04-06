# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service service/readahead/stopper
	iset last
	iexec start = stopper_start
	idone

	ireg daemon service/readahead/watcher-desktop
	iset need = system/mountfs/essential
	iset also_start = service/readahead/stopper
	iset forks
	iexec daemon = watcher_desktop_daemon
	idone

	ireg daemon service/readahead/watcher
	iset need = system/mountfs/essential
	iset also_start = service/readahead/stopper
	iset forks
	iset pid_file = "/var/run/readahead-watch.pid"
	iexec daemon = watcher_daemon
	idone

	ireg service service/readahead/desktop
	iset need = system/mountfs/essential
	iexec start = desktop_start
	idone

	ireg service service/readahead
	iset need = system/mountfs/essential
	iexec start
	idone
}

stopper_start()
{
    [ -e /var/run/readahead-watch.pid ] && kill `cat /var/run/readahead-watch.pid`
    [ -e /var/run/readahead-watch-boot.pid ] && kill `cat /var/run/readahead.pid`
    exit 0
}

watcher-desktop_daemon()
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

watcher_daemon()
{

	# If /usr or /var is mounted on another filesystem, make sure they will also be checked
	mountpoint -q /usr &&
		@/sbin/ngc@ --quiet --instant -u service/readahead/watcher-desktop
	mountpoint -q /var &&
		@/sbin/ngc@ --quiet --instant -u service/readahead/watcher-desktop

	# Okay, launch watcher.
	exec @/usr/sbin/readahead-watch@ -o /etc/readahead/boot;

	exit 1
}

desktop_start()
{
	[ -e /etc/readahead/desktop -a -x @/sbin/readahead-watch@ ] &&
		exec @/sbin/readahead-watch@ -o /etc/readahead/desktop
	exit 0
}

start()
{
	# Check if @/usr/sbin/readahead-list@ exits.
	[ -x @/usr/sbin/readahead-list@ ] || exit 0

	# The recent implention uses @/sbin/readahead-watch@ to get the list
	if [ -e /etc/readahead/boot ]
	then
		echo " Reading ahead, from list /etc/readahead/boot "
		exec @/usr/sbin/readahead-list@ /etc/readahead/boot
		exit 1
	else
		# if the watcher exist, generate /etc/readahead/boot
		echo "Starting service/readahead/watcher, to collect boot record data "
		@/sbin/ngc@ --instant --quiet -u service/readahead/watcher
		# Sleep 4 seconds, so readahead-watcher really stars, and got all.
		echo "Sleep 4"
		sleep 1
		echo "Sleep 3"
		sleep 1
		echo "Sleep 2"
		sleep 1
		echo "Sleep 1"
		sleep 1
	fi

	# This is the old location for readahead file
	[ -e /etc/readahead/readahead ] &&
		exec @/usr/sbin/readahead-list@ /etc/readahead/readahead
	exit 0
}
