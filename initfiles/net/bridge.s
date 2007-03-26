# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister -s "net/bridge/if/*/*" service
	iregister -s "net/bridge/br/*" service

	iset -s "net/bridge/if/*/*" need = "system/bootmisc ${CATEGORY}"
	iset -s "net/bridge/if/*/*" exec start = "@brctl@ addif ${CATEGORY##*/} ${NAME}"
	iset -s "net/bridge/if/*/*" exec stop = "@brctl@ delif ${CATEGORY##*/} ${NAME}"
	iset -s "net/bridge/br/*" need = "system/bootmisc"
	iset -s "net/bridge/br/*" exec start = "@brctl@ addbr ${NAME}"
	iset -s "net/bridge/br/*" exec stop = "@brctl@ delbr ${NAME}"

	idone -s "net/bridge/if/*/*"
	idone -s "net/bridge/br/*"
}
