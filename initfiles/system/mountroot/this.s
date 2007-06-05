# SERVICE: system/mountroot
# NAME:
# DESCRIPTION:
# WWW:

dm_dir="/dev/mapper"
dm_file="${dm_dir}/control"

setup()
{
	iregister service
		iset need = system/initial system/mountroot/rootrw
		iexec start
	idone
}

start()
{
	if ! : > /etc/mtab; then
		echo "Skipping /etc/mtab initialization (ro root?)"
		exit 0
	fi
	# Add the entry for / to mtab
	@mount@ -f /

	# Don't list root more than once
	@grep@ -v " / " /proc/mounts >>/etc/mtab

	# Remove stale backups
	@rm@ -f /etc/mtab~ /etc/mtab~~

	# Return Happily., or sulogin will be executed.
	exit 0
}
