@echo off
setlocal enabledelayedexpansion enableextensions

set cc_intel=icl
set cc_msvc=cl
set linker_msvc=link
set linker_intel=xilink
set liblinker=lib

:: modify according to your system configuration
set arch=x64
set useintel=1

:: Set folders
set SRC=./src/
set BIN=./bin/
set BUILD=./build/

if %useintel% == 1 (
    set compiler=%cc_intel%
    set linker=%linker_intel%
    set cflags=/O3
    set lflags=
) else (
    set compiler=%cc_msvc%
    set linker=%linker_msvc%
    set cflags=/O2
    set lflags=
)

set EXE=iapws_%COMPILER%_win_%arch%.exe

if "%1" == "" goto all

if "%1" == "all" goto all

if "%1" == "clean" goto clean

if "%1" == "cleanall" goto cleanall

:: compile only one file
echo "Compiling... "%1"
%compiler% %cflags% /c %SRC%%1.c /Fo%BUILD%%1.obj
goto exit

:: compile all files
:all
for %%f in (%SRC%*.c) do (
    echo "Compiling...  %%f"
    %compiler% %cflags% /c %SRC%%%~nf.c /Fo%BUILD%%%~nf.obj
)
:: Link
set objs=
for %%f in (%BUILD%*.obj) do (
    set objs=!objs! %BUILD%%%f
)
%linker% %lflags% %objs% /out:%BIN%%EXE%
goto exit

:clean
rm -rf %BUILD%*.obj
goto exit

:cleanall
rm -rf %BUILD%*.obj
rm -rf %BIN%*cl*.exe
goto exit

:exit
