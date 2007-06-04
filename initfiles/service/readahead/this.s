# SERVICE: service/readahead
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/mountfs/essential
		iexec start
	idone
}

start()
{
	# Check if @/usr/sbin/readahead-list@ exits.
	[ -x @/usr/sbin/readahead-list@ ] || exit 0

	# The recent implention uses @/sbin/readahead-watch@ to get the list
	if [ -e /etc/readahead/boot ]; then
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
