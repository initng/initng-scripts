# NAME: VDR
# DESCRIPTION: Video Disk Recorder - DVB Personal Video Recorder
# WWW: http://www.cadsoft.de/vdr

USER="vdr"
GROUP="video"
HOME="/var/vdr"
CONFIG="/etc/vdr"
SVDRP_PORT="2001"
EPGFILE="${HOME}/epg.data"
LANG="de_DE"
source /etc/conf.d/vdr

setup()
{
	ireg daemon daemon/vdr
	iset need = system/bootmisc
	iset use = daemon/lircd
	iset respawn
	iset stdall = /var/log/vdr.log
	iset chdir = "${HOME}"
	iset suid = "${USER}"
	iset sgid = "${GROUP}"
	iexec daemon
	idone
}

daemon()
{
	for plugin in ${PLUGINS}
	do
		# no joke!
		eval plugins=\"\${plugins} --plugin=\'\${plugin} \${plugin_${plugin}}\'\"
	done

	# why too complicated? su has a new environment,
	# HOME for example is definitiv an other value.
	# so we replace first all vars via eval and then we enter su.
	# no variable should be replaced!
	eval "exec @/usr/bin/vdr@ \
			--config='${CONFIG}' \
			--video='${HOME}' \
			--epgfile='${EPGFILE}' \
			--port='${SVDRP_PORT}' \
			${VDR_EXTRA_OPTIONS} \
			${plugins}"
}
