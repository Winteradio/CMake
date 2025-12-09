# ------ Set the variables for the library options ------- #
message(STATUS "# Set the options for the library : ${PROJECT_NAME}")

set(INCLUDE_DIR ${CMAKE_BINARY_DIR}/include CACHE PATH "Include files Path")
set(LIB_DIR ${CMAKE_BINARY_DIR}/lib CACHE PATH "Library files Path")
set(BIN_DIR ${CMAKE_BINARY_DIR}/bin CACHE PATH "Execute files Path")

message(STATUS "- The Binary Directory : ${BIN_DIR}")
message(STATUS "- The Library Directory : ${LIB_DIR}")
message(STATUS "- The Include Directory : ${INCLUDE_DIR}")

# ------ Set the options for the library ------- #
function(create_library)
	cmake_parse_arguments(
		ARG # Options / Single Value / Multi Value
		""	
		"LIBRARY_TYPE;TARGET_NAME;"
		"PUBLIC_HEADERS;PRIVATE_SOURCES"
		${ARGN})

	if (NOT DEFINED ARG_TARGET_NAME)
		set(ARG_TARGET_NAME ${PROJECT_NAME})
		message(DEBUG "# Debug : The library will use the project name as the target name")
	endif()

	if (NOT DEFINED ARG_LIBRARY_TYPE)
		set(ARG_LIBRARY_TYPE "STATIC")
		message(DEBUG "# Debug : The library will be a static library")
	endif()

	# if (NOT DEFINED ARG_PUBLIC_HEADERS)
	# 	set(ARG_PUBLIC_HEADERS)
	# 	message(DEBUG "# Debug : The library's header files is empty")
	# endif()

	# if (NOT DEFINED ARG_PRIVATE_SOURCES)
	# 	set(ARG_PRIVATE_SOURCES)
	# 	message(DEBUG "# Debug : The library's sources files is empty")
	# endif()

	if (${ARG_LIBRARY_TYPE} STREQUAL "STATIC")
		set(LIBRARY_TYPE STATIC)
	elseif(${ARG_LIBRARY_TYPE} STREQUAL "SHARED")
		set(LIBRARY_TYPE SHARED)
	elseif(${ARG_LIBRARY_TYPE} STREQUAL "MODULE")
		set(LIBRATY_TYPE MODULE)
	elseif(${ARG_LIBRARY_TYPE} STREQUAL "INTERFACE")
		set(LIBRARY_TYPE INTERFACE)
	else()
		message(FATAL_ERROR "# Fatal Error : The library type(${ARG_LIBRARY_TYPE}) is invalid")
	endif()

	message(STATUS "# Create the library : ${ARG_TARGET_NAME}")
	message(STATUS "- The Library Type : ${LIBRARY_TYPE}")

	add_library(${ARG_TARGET_NAME} ${LIBRARY_TYPE})

	target_sources(${ARG_TARGET_NAME}
		PUBLIC		${ARG_PUBLIC_HEADERS}
		PRIVATE		${ARG_PRIVATE_SOURCES}
	)

	if (WIN32 AND ${ARG_LIBRARY_TYPE} STREQUAL "SHARED")
		set_target_properties(${ARG_TARGET_NAME} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS ON)
	endif()

	set_target_properties(${ARG_TARGET_NAME} PROPERTIES
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
	)

endfunction()

# ------ Copy the public header files for the library ------- #
function(install_library)
	cmake_parse_arguments(
		ARG # Options / Single Value / Multi Value
		""	
		"TARGET_NAME;INCLUDE_PROPERTY;"
		"INCLUDE_DIRS;"
		${ARGN})

	if (NOT DEFINED ARG_TARGET_NAME)
		set(ARG_TARGET_NAME ${PROJECT_NAME})
		message(DEBUG "# Debug : The library will use the project name as the target name")
	endif()

	if (NOT DEFINED ARG_INCLUDE_DIRS)
		set(ARG_INCLUDE_DIRS "")
		message(DEBUG "# Debug : The include directories list is empty")
	endif()

	if (NOT DEFINED ARG_INCLUDE_PROPERTY)
		set(ARG_INCLUDE_PROPERTY "PUBLIC")
		message(DEBUG "# Debug : The include property is empty")
	endif()

	if (${ARG_INCLUDE_PROPERTY} STREQUAL "PUBLIC")
		set(INCLUDE_PROPERTY PUBLIC)
	elseif(${ARG_INCLUDE_PROPERTY} STREQUAL "PRIVATE")
		set(INCLUDE_PROPERTY PRIVATE)
	elseif(${ARG_INCLUDE_PROPERTY} STREQUAL "INTERFACE")
		set(INCLUDE_PROPERTY INTERFACE)
	else()
		message(FATAL_ERROR "# Fatal Error : The include property(${ARG_INCLUDE_PROPERTY}) is invalid")
	endif()

	message(STATUS "# Install the library : ${ARG_TARGET_NAME}")

	target_include_directories(${ARG_TARGET_NAME} ${INCLUDE_PROPERTY} ${ARG_INCLUDE_DIRS} ${INCLUDE_DIR})

	install(TARGETS ${ARG_TARGET_NAME}
		RUNTIME DESTINATION ${BIN_DIR}
		ARCHIVE DESTINATION ${LIB_DIR}
		LIBRARY DESTINATION ${LIB_DIR}
	)

	install(DIRECTORY ${ARG_INCLUDE_DIRS}/ DESTINATION ${INCLUDE_DIR}/${ARG_TARGET_NAME})

endfunction()


