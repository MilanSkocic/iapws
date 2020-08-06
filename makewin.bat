@echo off
:: use your available compiler either msvc or intel for windows
:: set the compiler environment according to instruction provided by microsoft or intel
:: usually a script must be ran before compiling (psxevars.bat for intel or vcvarsall.bat for microsoft)
:: for linux use the makefile

:: Set folders
set SRC=./src/
set BUILD=./build/
set BIN=./bin/
set arch=x64
set os=win

set msvc=cl
set msvcflags=-O3

set icc=icl
set iccflags=-O3

set intelcompiler=0

if %intelcompiler%==1 (
echo "INTEL"
set CC=%icc%
set CFLAGS=%iccflags%
) else (
echo "MSVC"
set CC=%msvc%
set CFLAGS=%msvcflags%
)

set EXE=iapws_%CC%_%os%_%arch%.exe

if "%1" == "" goto all

if "%1" == "all" goto all

if "%1" == "clean" goto clean

if "%1" == "cleanall" goto cleanall

:all
for %%f in (%SRC%*.c) do (
    echo "Compiling...  %%f"
    %CC% /c %SRC%%%~nf.c /Fo%BUILD%%%~nf.obj
)
link %BUILD%*.obj /out:%BIN%%EXE%
goto exit

:clean
rm -rf %BUILD%*.obj
goto exit

:cleanall
rm -rf %BUILD%*.obj
rm -rf %BIN%*cl*.exe
goto exit

:exit




