# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/pbbuttonsd && {
		iset need = service/alsasound virtual/net/lo
		iset exec daemon = "@/usr/bin/pbbuttonsd@"
	}
}
