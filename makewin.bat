@echo off
:: use your available compiler either msvc or intel for windows
:: set the compiler environment according to instruction provided by microsoft or intel
:: usually a script must be ran before compiling (psxevars.bat for intel or vcvarsall.bat for microsoft)
:: for linux use the makefile

:: Set folders
set SRC=./src/
set BUILD=./build/
set BIN=./bin/
set EXE=iapws_win.exe

set msvc=cl
set msvcflags=-O3

set icc=icl
set iccflags=-O3

set intelcompiler=1

if %intelcompiler%==1 (
echo "INTEL"
set CC=%icc%
) else (
echo "MSVC"
set CC=%msvc%
)

if "%1" == "" goto all

if "%1" == "all" goto all

if "%1" == "clean" goto clean

if "%1" == "cleanall" goto cleanall

:all
%CC% /c %SRC%main.c /Fo%BUILD%main.obj
%CC% /c %SRC%functions.c /Fo%BUILD%functions.obj
link %BUILD%main.obj %BUILD%functions.obj /out:%BIN%%EXE%
goto exit

:clean
rm -rf %BUILD%*.obj
goto exit

:cleanall
rm -rf %BUILD%*.obj
rm -rf %BIN%*_win.exe
goto exit

:exit




