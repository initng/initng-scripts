# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset use = "system/modules system/udev"

	iexec start = dmraid_start
	iexec stop = dmraid_stop

	idone
}

dmraid_start()
{
	    /sbin/dmraid --activate yes --ignorelocking
}

dmraid_stop()
{
	    /sbin/dmraid --activate no --ignorelocking
    }
}
