# NAME:
# DESCRIPTION:
# WWW:

setup()
{
    env
    
	echo "SERVICE: \"$SERVICE\""
	
	if [ "$SERVICE" = "system/getty" ]
	then
	    echo "This is main sytem/getty"
		iregister virtual
		iset need = system/getty/2 \
			    system/getty/3 \
			    system/getty/4 \
			    system/getty/5 \
			    system/getty/6
		iset use = system/mountfs/essential service/issue
		idone
		exit 0
	fi
	
	echo "This is child getty $NAME "

	iregister daemon
	#iset need = system/bootmisc system/mountfs/home
	iset provide = "virtual/getty/$NAME"
	iset term_timeout = 3
	iset respawn
	[ "${NAME}" = 1 ] && iset last
	iset exec daemon = "@/sbin/getty@ 38400 tty$NAME"
	idone
}
