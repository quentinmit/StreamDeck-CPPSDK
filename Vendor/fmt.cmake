include(ExternalProject)

ExternalProject_add(
  fmt_source
  URL https://github.com/fmtlib/fmt/releases/download/6.2.1/fmt-6.2.1.zip
  URL_HASH SHA512=e0bd78f2e554063591d9ac27bf7c1c3e6280c3129ac38d3b008c825bc9bfdfeb76bd6728abfec1cdfc12eb0d4efa0d0337c2eaf068d2f17b6bbb62b3fddd4126
  CMAKE_ARGS
    -DCMAKE_POLICY_DEFAULT_CMP0091=NEW # Support CMAKE_MSVC_RUNTIME_LIBRARY
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_MSVC_RUNTIME_LIBRARY=${CMAKE_MSVC_RUNTIME_LIBRARY}
    -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    -DFMT_DOC=OFF
    -DFMT_TEST=OFF
)
add_library(fmt INTERFACE )
add_dependencies(fmt fmt_source)
ExternalProject_Get_Property(fmt_source INSTALL_DIR)
target_include_directories(fmt INTERFACE "${INSTALL_DIR}/include")
set(FMT_RELEASE_LIB "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}fmt${CMAKE_STATIC_LIBRARY_SUFFIX}")
set(FMT_DEBUG_LIB "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}fmtd${CMAKE_STATIC_LIBRARY_SUFFIX}")
target_link_libraries(
  fmt
  INTERFACE
  optimized
  "${FMT_RELEASE_LIB}"
  debug
  "${FMT_DEBUG_LIB}"
)

install(
  FILES
  "$<IF:$<CONFIG:Debug>,${FMT_DEBUG_LIB},${FMT_RELEASE_LIB}>"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
install(
  DIRECTORY
  "${INSTALL_DIR}/include/fmt"
  DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)
