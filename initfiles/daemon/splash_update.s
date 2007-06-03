# SERVICE: daemon/splash_update
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset exec daemon = "@/sbin/splash_update@"
	idone
}
