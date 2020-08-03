# for comiling on windows use the makewin.bat script

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
EXE=$(BIN)/iapws_linux.exe

all: $(EXE)

$(EXE): $(OBJ)
	$(CC) -o $@ $^ $(FFLAGS)

$(BUILD)/%.o: $(SRC)/%.c
	$(CC) -o $@ -c $< $(FFLAGS)

.PHONY: clean cleanall run

clean:
	rm -rf $(BUILD)/*.o

cleanall: clean
	rm -rf $(BIN)/*.exe

run: all
	$(BIN)/iapws    
