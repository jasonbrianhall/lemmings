# Compiler
CXX := g++

# FMOD API path
FMOD_PATH := ./fmodstudioapi20224linux

# Installation paths
INSTALL_PATH := /usr/local/games/lemmings
INSTALL_LIB_PATH := $(INSTALL_PATH)/lib

# Compiler flags
CXXFLAGS := -std=c++11 -Wall -Wextra \
    -I$(FMOD_PATH)/api/core/inc \
    -I$(FMOD_PATH)/api/studio/inc \
    $(shell pkg-config --cflags glut glew gl glu) \
    -I/usr/include/SOIL

# Linker flags
LDFLAGS := \
    -L$(FMOD_PATH)/api/core/lib/x86_64 \
    -L$(FMOD_PATH)/api/studio/lib/x86_64

# Libraries
LIBS := -lfmod -lfmodstudio $(shell pkg-config --libs glut glew gl glu) -lSOIL

# Source directory
SRC_DIR := src

# Object directory
OBJ_DIR := obj

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)

# Object files
OBJS := $(SRCS:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)

# Executable name
EXEC := lemmings

# Main target
$(EXEC): $(OBJS)
	$(CXX) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBS)

# Rule for object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Install target
install: $(EXEC)
	install -d $(INSTALL_PATH)
	install -d $(INSTALL_LIB_PATH)
	install -m 755 $(EXEC) $(INSTALL_PATH)
	install -m 644 $(FMOD_PATH)/api/core/lib/x86_64/libfmod.so* $(INSTALL_LIB_PATH)
	install -m 644 $(FMOD_PATH)/api/studio/lib/x86_64/libfmodstudio.so* $(INSTALL_LIB_PATH)
	cp -R Game/* $(INSTALL_PATH)
	@echo "Creating launch script..."
	@echo '#!/bin/bash' > /usr/local/bin/lemmings
	@echo 'cd $(INSTALL_PATH) && LD_LIBRARY_PATH=$(INSTALL_LIB_PATH):$ ./lemmings' >> /usr/local/bin/lemmings
	chmod +x /usr/local/bin/lemmings
	@echo "Updating library cache..."
	echo $(INSTALL_LIB_PATH) > /etc/ld.so.conf.d/lemmings.conf
	ldconfig

# Clean rule
clean:
	rm -rf $(OBJ_DIR) $(EXEC)

# Uninstall target
uninstall:
	rm -rf $(INSTALL_PATH)
	rm -f /usr/local/bin/lemmings
	rm -f /etc/ld.so.conf.d/lemmings.conf
	ldconfig

# Phony targets
.PHONY: clean install uninstall
