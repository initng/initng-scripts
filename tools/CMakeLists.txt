ADD_EXECUTABLE(install_service_file install_service_file.c)
INSTALL_TARGETS(${SBIN_INSTALL_DIR} install_service_file)
INSTALL_PROGRAMS(${SBIN_INSTALL_DIR} ng-update)
