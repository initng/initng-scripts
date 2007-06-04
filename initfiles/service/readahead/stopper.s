# SERVICE: service/readahead/stopper
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister task
		iset last
		iset once
		iexec task
	idone
}

task()
{
    [ -e /var/run/readahead-watch.pid ] && kill $(cat /var/run/readahead-watch.pid)
    [ -e /var/run/readahead-watch-boot.pid ] && kill $(cat /var/run/readahead.pid)
    exit 0
}
