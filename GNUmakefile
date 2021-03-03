# Compile on Linux and/or with msys2 on windows

include make.in
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
GCC=$(GNU)
GCFLAGS = -O3 -Wall

# Set Intel compiler and flags
ICC=icc
ICFLAGS = -O3

# Choose which compiler
CC=$(GCC)
CFLAGS=$(GCFLAGS)

OBJ = $(patsubst $(SRC)/%.c,$(BUILD)/%.o, $(wildcard ./src/*.c))
EXE=$(BIN)/iapws_$(CC)_$(OSFLAG).exe

all: $(EXE)

$(EXE): $(OBJ)
	$(CC) -o $@ $^ $(GLDFLAGS) -static

$(BUILD)/%.o: $(SRC)/%.c
	$(CC) -o $@ -c $< $(GCFLAGS)

.PHONY: clean cleanall

clean:
	rm -rf $(BUILD)/*.o

cleanall: clean
	rm -rf $(BIN)/*gcc*

