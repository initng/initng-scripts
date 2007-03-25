# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/initial"
	iset provide = "virtual/firewall"

	iexec start = guarddog_start

	idone
}

guarddog_start()
{
	script stop = {
		if [ ! -x @/sbin/iptables:/sbin/ipchains@ ]
		then
			echo "Cannot find @/sbin/ipchains@ or @/sbin/iptables@"
			exit 1
		fi
		@/sbin/iptables:/sbin/ipchains@ -P OUTPUT ACCEPT
		@/sbin/iptables:/sbin/ipchains@ -P INPUT ACCEPT
		@/sbin/iptables:/sbin/ipchains@ -P FORWARD ACCEPT
		@/sbin/iptables:/sbin/ipchains@ -F
		@/sbin/iptables:/sbin/ipchains@ -X
		exit 0
}
