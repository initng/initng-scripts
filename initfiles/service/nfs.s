# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="service/nfs"
	iregister virtual
	iset need = "service/exportfs daemon/gssd daemon/idmapd daemon/mountd daemon/nfsd daemon/statd daemon/svcgssd"
	iset use = "daemon/rquotad"
	idone
}
