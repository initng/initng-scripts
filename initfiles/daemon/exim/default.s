# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual daemon/exim && {
		iset need = system/bootmisc virtual/net \
	        	    daemon/exim/updateconf daemon/exim/queuerunner \
			    daemon/exim/listner
		iset also_stop = daemon/exim/queuerunner daemon/exim/listner
	}
}
