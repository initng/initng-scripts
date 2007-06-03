# SERVICE; daemon/mit-krb5kdc
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon
		iset need = system/bootmisc virtual/net
		iset exec daemon = "@/usr/sbin/krb5kdc@ -n"
	idone
}
