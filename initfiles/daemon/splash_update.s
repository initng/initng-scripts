# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/splash_update && {
		iset exec daemon = "@/sbin/splash_update@"
	}
}
