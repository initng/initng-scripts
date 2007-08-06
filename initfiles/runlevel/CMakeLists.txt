SET(RUNLEVEL_FILES
	fake-default.runlevel
	single.runlevel
)

CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/any.in"
               "${CMAKE_CURRENT_BINARY_DIR}/any"
               IMMEDIATE @ONLY)

INSTALL_PROGRAMS(${SYSCONF_INSTALL_DIR}/initng/runlevel FILES any)

INSTALL_FILES(${SYSCONF_INSTALL_DIR}/initng/runlevel FILES ${RUNLEVEL_FILES})
