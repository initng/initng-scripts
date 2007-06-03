SUBDIRS(
	acpid
	automount
	bluetooth
	dhcpcd
	dropbear
	exim
	gnump3d
	ifplugd
	instant-gdm
	ipw3945d
	lirc
	mysql
	networkmanager
	nut
	openvpn
	postfix
	postgres
	powersaved
	pump
	samba
	sendmail
	sshd
	syslogd
	udhcpc
	vmware
	wpa_cli
	wpa_supplicant
	wwwoffle
	xfs
)

FILE(GLOB S_FILES "*.s")

PROCESS_SFILES(SERVICE_FILES ${S_FILES})

INSTALL_PROGRAMS(${SYSCONF_INSTALL_DIR}/initng/daemon FILES ${SERVICE_FILES})
