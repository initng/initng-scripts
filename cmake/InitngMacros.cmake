MACRO(PROCESS_SFILES _s_FILES)
	# reset the variable
	SET(${_s_FILES})

	FOREACH(_current_FILE ${ARGN})
		GET_FILENAME_COMPONENT(_tmp_FILE ${_current_FILE} ABSOLUTE)
		GET_FILENAME_COMPONENT(_abs_PATH ${_tmp_FILE} PATH)
		GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)
		SET(_s_FILE ${CMAKE_CURRENT_BINARY_DIR}/${_basename})
		
		ADD_CUSTOM_COMMAND(OUTPUT ${_s_FILE}
			COMMAND ${CMAKE_BINARY_DIR}/tools/install_service_file
			ARGS -i ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE} -o ${_s_FILE} > /dev/null 2>&1
			DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE} ${CMAKE_BINARY_DIR}/tools/install_service_file)
		
		SET(${_s_FILES} ${${_s_FILES}} ${_s_FILE})
			
	ENDFOREACH(_current_FILE)

	ADD_CUSTOM_TARGET(sfiles ALL 
		DEPENDS ${${_s_FILES}})	

ENDMACRO(PROCESS_SFILES)
