# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s "service/readahead/stopper" service
	iregister -s "service/readahead/watcher-desktop" daemon
	iregister -s "service/readahead/watcher" daemon
	iregister -s "service/readahead/desktop" service
	iregister -s "service/readahead" service

	iset -s "service/readahead/stopper" last
	iset -s "service/readahead/watcher-desktop" need = "system/mountfs/essential"
	iset -s "service/readahead/watcher-desktop" also_start = "service/readahead/stopper"
	iset -s "service/readahead/watcher-desktop" forks
	iset -s "service/readahead/watcher" need = "system/mountfs/essential"
	iset -s "service/readahead/watcher" also_start = "service/readahead/stopper"
	iset -s "service/readahead/watcher" forks
	iset -s "service/readahead/watcher" pid_file = "/var/run/readahead-watch.pid"
	iset -s "service/readahead/desktop" need = "system/mountfs/essential"
	iset -s "service/readahead" need = "system/mountfs/essential"

	iexec -s "service/readahead/stopper" start = stopper_start
	iexec -s "service/readahead/watcher-desktop" daemon = watcher-desktop_daemon
	iexec -s "service/readahead/watcher" daemon = watcher_daemon
	iexec -s "service/readahead/desktop" start = desktop_start
	iexec -s "service/readahead" start = readahead_start

	idone -s "service/readahead/stopper"
	idone -s "service/readahead/watcher-desktop"
	idone -s "service/readahead/watcher"
	idone -s "service/readahead/desktop"
	idone -s "service/readahead"
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
	    if mountpoint -q /usr; then
		dirs="$dirs /usr"
	    fi

	    # Add /var to dirs, if that is a mountpoint
	    if mountpoint -q /var; then
		dirs="$dirs /var"
	    fi

	    exec @/usr/sbin/readahead-watch@ -o /etc/readahead/desktop $dirs

	    #Never get here
	    exit 1
}

watcher_daemon()
{

	    # If /usr or /var is mounted on another filesystem, make sure they will also be checked
	    mountpoint -q /usr && @/sbin/ngc@ --quiet --instant -u service/readahead/watcher-desktop
	    mountpoint -q /var && @/sbin/ngc@ --quiet --instant -u service/readahead/watcher-desktop

	    # Okay, launch watcher.
	    exec @/usr/sbin/readahead-watch@ -o /etc/readahead/boot;

	    exit 1
}

desktop_start()
{
	    if [ -e /etc/readahead/desktop ]
	    then
		[ -x @/sbin/readahead-watch@ ] && exec @/sbin/readahead-watch@ -o /etc/readahead/desktop
	    fi
	    exit 0
}

readahead_start()
{
		# Check if @/usr/sbin/readahead-list@ exits.
		if [ -x @/usr/sbin/readahead-list@ ]
		then

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
			if [ -e /etc/readahead/readahead ]
			then
			exec @/usr/sbin/readahead-list@ /etc/readahead/readahead
			fi

		fi
		exit 0
}
