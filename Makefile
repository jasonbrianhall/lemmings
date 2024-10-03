# Compiler
CXX := g++

# FMOD API path
FMOD_PATH := ./fmodstudioapi20224linux

# Compiler flags
CXXFLAGS := -std=c++11 -Wall -Wextra \
	-I$(FMOD_PATH)/api/core/inc \
	-I$(FMOD_PATH)/api/studio/inc \
	-I/usr/include/GL

# Linker flags
LDFLAGS := \
	-L$(FMOD_PATH)/api/core/lib/x86_64 \
	-L$(FMOD_PATH)/api/studio/lib/x86_64

# Libraries
LIBS := -lfmod -lfmodstudio -lglut -lGLEW -lSOIL -lGL -lGLU

# Source directory
SRC_DIR := src

# Object directory
OBJ_DIR := obj

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)

# Object files
OBJS := $(SRCS:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)

# Executable name
EXEC := Game/lemmings

# Main target
$(EXEC): $(OBJS)
	$(CXX) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBS)

# Rule for object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean rule
clean:
	rm -rf $(OBJ_DIR) $(EXEC)

# Phony targets
.PHONY: clean
