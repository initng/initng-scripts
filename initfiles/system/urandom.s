# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
source /etc/default/rcS
POOLSIZE="512"
SAVEDFILE="/var/lib/urandom/random-seed"
#elsed
SAVEDFILE="/var/run/random-seed"
#endd

setup()
{
	ireg service system/urandom
	iset need = system/bootmisc
	iexec start
	iexec stop
	idone
}

start()
{
#ifd debian
	[ -f /proc/sys/kernel/random/poolsize ] && POOLSIZE="`@cat@ /proc/sys/kernel/random/poolsize`"
	# Load and then save ${POOLSIZE} bytes,
	# which is the size of the entropy pool
	if [ -f ${SAVEDFILE} ]
	then
		# Handle locally increased pool size
		SAVEDSIZE=`stat -c"%s" ${SAVEDFILE}`
		if [ ${SAVEDSIZE} -gt ${POOLSIZE} ]
		then
			[ -w /proc/sys/kernel/random/poolsize ] && echo ${POOLSIZE} > /proc/sys/kernel/random/poolsize
			POOLSIZE=${SAVEDSIZE}
		fi
		@cat@ ${SAVEDFILE} >/dev/urandom
	fi
#elsed
	[ -c /dev/urandom ] || exit 1
	[ -f "${SAVEDFILE}" ] && @cat@ "${SAVEDFILE}" >/dev/urandom
#endd
	if ! @rm@ -f "${SAVEDFILE}" 2>&1 >/dev/null
	then
		echo "Skipping ${SAVEDFILE} initialization (ro root?)"
		exit 1
	fi
	umask 077
	@dd@ if=/dev/urandom of=${SAVEDFILE} count=1 >/dev/null 2>&1
}

stop()
{
	umask 077
#ifd debian
	@dd@ if=/dev/urandom of=${SAVEDFILE} bs=${POOLSIZE} count=1 >/dev/null 2>&1
#elsed
	@dd@ if=/dev/urandom of=${SAVEDFILE} count=1 >/dev/null 2>&1
#endd
}
