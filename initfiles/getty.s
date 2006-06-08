#!/sbin/runiscript

setup()
{
	#if getty service
	if [ "$SERVICE" == "getty" ]
	then
		iregister -s getty virtual
		
		# Make it need 6 new gettys
		for SE in tty1 tty2 tty3 tty4 tty5 tty6
		do
			iset -s getty need = getty/$SE
		done
		idone -s getty
		exit 0
	fi
	
	# else its a getty termainal
	iregister daemon
	iset need = initial bootmisc
	iset term_timeout = 3
	iset exec daemon = "@/sbin/getty@ 38400 $NAME"
	iset respawn
	idone
}
