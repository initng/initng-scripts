
SET(S_FILES
	bootmisc.s
	checkfs.s
	clock.s
	default.s
	fake-default.s
	getty.s
	hostname.s
	ifupdown-debian.s
	initial.s
	keymaps.s
	modules.s
	mountfs.s
	mountroot.s
	net.s
	sysctl.s
	test.s
	udev.s
	up-fake.s
)

PROCESS_SFILES(SERVICE_FILES ${S_FILES})

INSTALL_PROGRAMS(${SYSCONF_INSTALL_DIR}/init FILES ${SERVICE_FILES})
