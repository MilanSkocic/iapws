# Compile on Linux and/or with msys2 on windows
# Otherwise use makewin.bat on windows

# detect os
OSFLAG 				:=
ifeq ($(OS),Windows_NT)
	ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
		OSFLAG = win_x64
	endif
	ifeq ($(PROCESSOR_ARCHITECTURE),x86)
		OSFLAG = win_x86
	endif
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OSFLAG = linux
	endif
	ifeq ($(UNAME_S),Darwin)
		OSFLAG = Darwin
	endif
		UNAME_P := $(shell uname -p)
	ifeq ($(UNAME_P),x86_64)
		OSFLAG += _x64
	endif
		ifneq ($(filter %86,$(UNAME_P)),)
	OSFLAG += _x86
		endif
	ifneq ($(filter arm%,$(UNAME_P)),)
		OSFLAG += _arm
	endif
endif

# Set GNU compiler and flags
GCC=gcc
GCFLAGS = -O3

# Set Intel compiler and flags
ICC=icc
ICFLAGS = -O3

# Choose which compiler
CC=$(GCC)
CFLAGS=$(GCFLAGS)

# Set folders
SRC=./src
BIN=./bin
BUILD=./build
OBJ = $(patsubst $(SRC)/%.c,$(BUILD)/%.o, $(wildcard ./src/*.c))
EXE=$(BIN)/iapws_$(CC)_$(OSFLAG).exe

all: $(EXE)

$(EXE): $(OBJ)
	$(CC) -o $@ $^ -lm

$(BUILD)/%.o: $(SRC)/%.c
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: clean cleanall

clean:
	rm -rf $(BUILD)/*.o

cleanall: clean
	rm -rf $(BIN)/*gcc*

