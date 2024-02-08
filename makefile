# Compiler and compiler flags
CXX := g++
CXXFLAGS := -std=c++23 -O3 -Wno-pmf-conversions -DIL_STD -g

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
INCLUDES := \
    -I /home/macsilva/cplex/cplex/include -I /home/macsilva/cplex/concert/include
LDFLAGS := \
    -L /home/macsilva/cplex/cplex/lib/x86-64_linux/static_pic  -L /home/macsilva/cplex/concert/lib/x86-64_linux/static_pic
LDLIBS := \
    -l concert -l ilocplex -l cplex -l m -l pthread -l dl \
    -l gmpxx -l gmp

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
