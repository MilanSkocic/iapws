# Windows specific makefile to be used with nmake

include make.in

!IF $(USEINTEL)==0
CC=$(MSVC)
COMPILER=cl
!ELSE
CC=$(INTEL)
COMPILER=icl
!ENDIF

OBJ = $(BUILD)/iapws.obj $(BUILD)/main.obj
EXE=$(BIN)/iapws_$(COMPILER)_win.exe

all: $(EXE)

$(EXE): $(OBJ)
	$(LINKER) $(WLDFLAGS) /out:$@ $**

$(BUILD)/iapws.obj: $(SRC)/iapws.c
	$(CC) /c $** $(WCFLAGS) /Fo$@

$(BUILD)/main.obj: $(SRC)/main.c
	$(CC) /c $** $(WCFLAGS) /Fo$@

.PHONY: clean cleanall

clean:
	rm -rf $(BUILD)/*.obj

cleanall: clean
	rm -rf $(BIN)/*cl*.exe
	rm -rf $(BIN)/*icl*.exe