# Compiler and compiler flags
CXX := g++
CXXFLAGS := -std=c++23 -O3 -Wno-pmf-conversions

# Directories
SRC_DIR := ./src
OBJ_DIR := ./obj
# Careful! ^^^^^ clean rule will remove this directory recursively.
BIN_DIR := .

# Source files and object files
SRCS := $(shell find $(SRC_DIR) -name '*.cpp')
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))

# Target binary
TARGET := $(BIN_DIR)/and_star

# External Dependencies
INCLUDES :=
LDFLAGS := 
LDLIBS := -l gmpxx -l gmp

# Phony targets
.PHONY: all clean

# Default target
all: $(TARGET)

# Build the binary
$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $@ $(LDFLAGS) $(LDLIBS)

# Compile source files into object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -MMD -MP $(INCLUDES) -c $< -o $@
-include $(OBJS:.o=.d)

# Clean objects and binary
clean:
	rm -rf $(OBJ_DIR)
	rm -f  $(TARGET)
