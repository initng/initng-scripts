# SERVICE: service/readahead/stopper
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset last
		iexec start
	idone
}

start() {
    [ -e /var/run/readahead-watch.pid ] && kill $(cat /var/run/readahead-watch.pid)
    [ -e /var/run/readahead-watch-boot.pid ] && kill $(cat /var/run/readahead.pid)
    exit 0
}
