# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/mit-krb5kdc
	iset need = system/bootmisc virtual/net
	iset exec daemon = "@/usr/sbin/krb5kdc@ -n"
	idone
}
