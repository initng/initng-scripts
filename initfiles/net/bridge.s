# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister -s "net/bridge/if/*/*" service
	iregister -s "net/bridge/br/*" service

	iset -s "net/bridge/if/*/*" need = "system/bootmisc ${CATEGORY}"
	iset -s "net/bridge/br/*" need = "system/bootmisc"

	iexec -s "net/bridge/if/*/*" start = "@brctl@ addif ${CATEGORY##*/} ${NAME}"
	iexec -s "net/bridge/if/*/*" stop = "@brctl@ delif ${CATEGORY##*/} ${NAME}"
	iexec -s "net/bridge/br/*" start = "@brctl@ addbr ${NAME}"
	iexec -s "net/bridge/br/*" stop = "@brctl@ delbr ${NAME}"

	idone -s "net/bridge/if/*/*"
	idone -s "net/bridge/br/*"
}

