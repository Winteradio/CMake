# ------ Set the basic options for the project ------- #
message(STATUS "# Set the basic options for the project")

function(project_options)
	cmake_parse_arguments(
		ARG # Options / Single Value / Multi Value
		""
		"TARGET_TYPE;"
		""
		${ARGN})

	if (NOT DEFINED ARG_TARGET_TYPE)
		set(ARG_TARGET_TYPE "PRIVATE")
	endif()

	if (${ARG_TARGET_TYPE} STREQUAL "PUBLIC")
		set(TARGET_TYPE PUBLIC)
	elseif (${ARG_TARGET_TYPE} STREQUAL "PRIVATE")
		set(TARGET_TYPE PRIVATE)
	elseif (${ARG_TARGET_TYPE} STREQUAL "INTERFACE")
		set(TARGET_TYPE INTERFACE)
	else()
		message(FATAL_ERROR "# Fatal Error : The target type(${ARG_TARGET_TYPE}) is invalid")
	endif()

	message(STATUS "- Compiler : ${CMAKE_CXX_COMPILER_ID}")

	target_compile_features(${PROJECT_NAME} ${TARGET_TYPE} cxx_std_17)

	if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
		add_compile_options(/Zi /MP)
	elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
		add_compile_options(-g -Wall -Wextra)
	elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
		add_compile_options(-g -Wall -Wextra)
	else()
		message(FATAL_ERROR "The Compiler ${CMAKE_CXX_COMPILER_ID} is not supported")
	endif()
endfunction()