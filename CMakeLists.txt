# cmake build file for squish
# by Stefan Roettger (stefan@stereofx.org)
# updated by Simon Brown (si@sjbrown.co.uk)

# features:
#   Xcode: builds universal binaries, uses SSE2 on i386 and Altivec on ppc
#   VS: TODO (assume x86 and use SSE2)
#   Unix: TODO (check architecture and define for SSE2 or Altivec or nothing accordingly)

PROJECT(squish)

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

OPTION(BUILD_EXTRA "Build extra directory." OFF)

SET(CMAKE_OSX_ARCHITECTURES i386;ppc)

IF (NOT CMAKE_GENERATOR STREQUAL "Xcode")
    IF (NOT APPLE) # TODO: improve architecture check
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DSQUISH_USE_SSE=2 -msse")
    ENDIF (NOT APPLE)
ENDIF (NOT CMAKE_GENERATOR STREQUAL "Xcode")

SET(SQUISH_HDRS
    squish.h
    )

SET(SQUISH_SRCS
    alpha.cpp
    alpha.h
    clusterfit.cpp
    clusterfit.h
    colourblock.cpp
    colourblock.h
    colourfit.cpp
    colourfit.h
    colourset.cpp
    colourset.h
    maths.cpp
    maths.h
    rangefit.cpp
    rangefit.h
    simd.h
    simd_float.h
    simd_sse.h
    simd_ve.h
    singlecolourfit.cpp
    singlecolourfit.h
    singlecolourlookup.inl
    squish.cpp
    )

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

ADD_DEFINITIONS(${SQUISH_DEFINES})
ADD_LIBRARY(squish ${SQUISH_SRCS} ${SQUISH_HDRS})

SET_TARGET_PROPERTIES(
    squish PROPERTIES
    PUBLIC_HEADER "${SQUISH_HDRS}"
    DEBUG_POSTFIX "d"
    XCODE_ATTRIBUTE_GCC_PREPROCESSOR_DEFINITIONS " $(SQUISH_CPP_$(CURRENT_ARCH))"
    XCODE_ATTRIBUTE_OTHER_CFLAGS " $(SQUISH_CFLAGS_$(CURRENT_ARCH))"
    XCODE_ATTRIBUTE_SQUISH_CPP_i386 "SQUISH_USE_SSE=2"
    XCODE_ATTRIBUTE_SQUISH_CPP_ppc "SQUISH_USE_ALTIVEC=1"
    XCODE_ATTRIBUTE_SQUISH_CFLAGS_i386 ""
    XCODE_ATTRIBUTE_SQUISH_CFLAGS_ppc "-maltivec"
    )

IF (BUILD_EXTRA)
    SET(SQUISHTEST_SRCS extra/squishtest.cpp)

    ADD_EXECUTABLE(squishtest ${SQUISHTEST_SRCS})
    SET_TARGET_PROPERTIES(squishtest PROPERTIES DEBUG_POSTFIX "d")
    TARGET_LINK_LIBRARIES(squishtest squish)

    SET(SQUISHPNG_SRCS extra/squishpng.cpp)

    FIND_PACKAGE(PNG)

    IF (PNG_FOUND)
        # TODO: check libpng and libz are built universal for Xcode?
        SET(CMAKE_PLATFORM_IMPLICIT_INCLUDE_DIRECTORIES)
        INCLUDE_DIRECTORIES(${PNG_INCLUDE_DIR})
        ADD_EXECUTABLE(squishpng ${SQUISHPNG_SRCS})
        SET_TARGET_PROPERTIES(squishpng PROPERTIES DEBUG_POSTFIX "d")
        TARGET_LINK_LIBRARIES(squishpng squish ${PNG_LIBRARIES})
    ENDIF (PNG_FOUND)
ENDIF (BUILD_EXTRA)

INSTALL(
    TARGETS squish
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    PUBLIC_HEADER DESTINATION include
    )
