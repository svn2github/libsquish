include config

SRC = alpha.cpp clusterfit.cpp colourblock.cpp colourfit.cpp colourset.cpp maths.cpp rangefit.cpp singlecolourfit.cpp squish.cpp

OBJ = $(SRC:%.cpp=%.o)

ifeq ($(HOSTTYPE),intel-pc) # intel-pc = macos x
   USE_SHARED = 0
endif

ifeq ($(USE_SHARED),1)
   VER = libsquish.so.0
   LIB = $(VER).0
   CPPFLAGS += -fPIC
else
   LIB = libsquish.a
endif

all: $(LIB)

install: $(LIB)
	install squish.h $(INSTALL_DIR)/include
	install $(LIB) $(INSTALL_DIR)/lib

uninstall:
	$(RM) $(INSTALL_DIR)/include/squish.h
	$(RM) $(INSTALL_DIR)/lib/$(LIB)

$(LIB): $(OBJ)
ifeq ($(USE_SHARED),1)
	$(CXX) -shared -Wl,-soname,$(VER) -o $@ $(OBJ)
else
	$(AR) cr $@ $?
	ranlib $@
endif

%.o: %.cpp
	$(CXX) $(CPPFLAGS) -I. $(CXXFLAGS) -o $@ -c $<

clean:
	$(RM) $(OBJ) $(LIB) Makefile
