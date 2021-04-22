@echo off

set useintel=1

:: modify accoridng to your system setup
set root="C:\Users\mskocic\Programming\C_FORTRAN\OpenSource\iapws"
set intel_folder="C:\Program Files (x86)\IntelSWTools\parallel_studio_xe_2020.2.899\bin\psxevars.bat"
set msvc_folder="C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

if %useintel% == 1 (
    call %intel_folder% intel64 vs2019
    cd %root%
) else (
    call %msvc_folder%
    cd %root%
)





