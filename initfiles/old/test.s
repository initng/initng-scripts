#!/sbin/runiscript

setup()
{
	# register new service type, the $SERVICE will be "example" here.
	iregister service

	iset stderr = /tmp/log
	iset nice = -4
	iset suid = nobody
	iset exec_delay start = 1
	iset chdir = /tmp
	iset rlimit_cpu_hard = 1
	iset rlimit_core_soft = 1000
	
	# add start() and stop() below
	iexec start
	iexec stop

	# Tell initng this service is done parsing.
	idone
}

start()
{
		echo "initng vers : ${INITNG}"
		echo "service name: ${NAME}"
		echo "service     : ${SERVICE}"
		echo "path        : ${CLASS}"
		echo "test        : ${TEST}"
		echo "i_am:       : `/usr/bin/whoami`"
		echo "nice:       : `/usr/bin/nice`"
		echo "pwd:        : `/bin/pwd`"
		echo "limits HARD:"
		ulimit -a -H
		echo "limits SOFT:"
		ulimit -a -S
	echo "And exec works!"
		echo "distribution: debian"
		echo -n "sleeping 1 : "
		echo "Hello  DEEEEEEEEEEEMO" >&4
		sleep 1
		echo done
		echo
		
		exit 0
}

stop()
{

		echo "initng vers : ${INITNG}"
		echo "service name: ${NAME}"
		echo "service     : ${SERVICE}"
		echo "path        : ${CLASS}"
		echo "test        : ${TEST}"
		echo "i_am:       : `whoami`"
		echo "nice:       : `nice`"
		echo "pwd:        : `/bin/pwd`"
		sleep 1
		echo -n "God"
		sleep 1
		echo  "Bye."
		echo
		#env
		exit 0
}
