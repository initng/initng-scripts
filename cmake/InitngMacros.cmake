MACRO(PROCESS_SFILES _service_FILES)
	# reset the variable
	SET(${_service_FILES})
	SET(_s_IGNORE)
	
	FOREACH(_current_FILE ${ARGN})
		GET_FILENAME_COMPONENT(_basename ${_current_FILE} NAME_WE)

		# process files only once
		IF(NOT _s_IGNORE MATCHES /${_basename}\\.s;)
			GET_FILENAME_COMPONENT(_abs_PATH ${_current_FILE} PATH)
			SET(_service_FILE ${CMAKE_CURRENT_BINARY_DIR}/${_basename})

			ADD_CUSTOM_COMMAND(OUTPUT ${_service_FILE}
				COMMAND ${CMAKE_BINARY_DIR}/tools/install_service_file
				ARGS -i ${_current_FILE} -o ${_service_FILE} > /dev/null 2>&1
				DEPENDS ${_current_FILE} ${CMAKE_BINARY_DIR}/tools/install_service_file)

			SET(${_service_FILES} ${${_service_FILES}} ${_service_FILE})

			# add to the list of processed files
			SET(_s_IGNORE ${_s_IGNORE} /${_basename}.s)
		ENDIF(NOT _s_IGNORE MATCHES /${_basename}\\.s;)
	ENDFOREACH(_current_FILE)
	
	ADD_CUSTOM_TARGET(sfiles ALL DEPENDS ${${_service_FILES}})

ENDMACRO(PROCESS_SFILES)

MACRO(GENERATE_RUNLEVEL)
	SET(_runlevel_FILES)
	FOREACH(_current_FILE ${ARGN})
		SET(_runlevel_FILE ${CMAKE_CURRENT_BINARY_DIR}/${_current_FILE})
		ADD_CUSTOM_COMMAND(OUTPUT ${_runlevel_FILE}
			COMMAND ${CMAKE_BINARY_DIR}/genrunlevel
			ARGS -confdir ${CMAKE_CURRENT_BINARY_DIR} ${_current_FILE} > /dev/null 2>&1
			DEPENDS ${CMAKE_SOURCE_DIR}/genrunlevel.in)

		SET(_runlevel_FILES ${_runlevel_FILES} ${_runlevel_FILE})

	ENDFOREACH(_current_FILE)

	ADD_CUSTOM_TARGET(runlevel ALL
		DEPENDS ${_runlevel_FILES})

ENDMACRO(GENERATE_RUNLEVEL)
