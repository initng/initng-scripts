SUBDIRS(
	alsasound
	chvt
	fbsplash
	init
	lm-sensors
	readahead
	splashy
)

FILE(GLOB S_FILES "*.s")

PROCESS_SFILES(SERVICE_FILES ${S_FILES})

INSTALL_PROGRAMS(${SYSCONF_INSTALL_DIR}/initng/service FILES ${SERVICE_FILES})
