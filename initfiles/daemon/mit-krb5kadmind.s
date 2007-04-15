# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/mit-krb5kadmind && {
		iset need = system/bootmisc daemon/mit-krb5kdc
		iset exec daemon = "@kadmind@ -nofork"
	}
}
