# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/bluetooth/pand && {
		iset need = system/bootmisc daemon/bluetooth/hcid
		iset exec daemon = "@/usr/bin/pand@ --nodetach --listen --role NAP"
	}
}
