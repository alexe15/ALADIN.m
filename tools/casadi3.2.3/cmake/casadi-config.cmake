# - Config file for the CasADi package
# It defines the following variables
#  CASADI_INCLUDE_DIRS - include directories for CasADi
#  CASADI_LIBRARY_DIRS - library directories for CasADi
#  CASADI_LIBRARIES    - libraries to link against

# Compute paths
get_filename_component(CASADI_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(CASADI_INCLUDE_DIRS "${CASADI_CMAKE_DIR}/../include")
set(CASADI_LIBRARY_DIRS "${CASADI_CMAKE_DIR}/../")

# Our library dependencies (contains definitions for IMPORTED targets)
if(NOT TARGET foo AND NOT CASADI_BINARY_DIR)
  include("${CASADI_CMAKE_DIR}/casadi-targets.cmake")
endif()

# These are IMPORTED targets created by casadi-targets.cmake
set(CASADI_LIBRARIES casadi)
