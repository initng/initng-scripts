SUBDIRS(
	agetty
	coldplug
	fgetty
	getty
	initial
	mingetty
	modules
	mountfs
	mountroot
	nvidia-glx
	qingy
	selinux
	udev
)


FILE(GLOB S_FILES "*.s")

PROCESS_SFILES(SERVICE_FILES ${S_FILES})

INSTALL_PROGRAMS(${SYSCONF_INSTALL_DIR}/initng/system FILES ${SERVICE_FILES})
