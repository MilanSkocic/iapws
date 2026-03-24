$BLOCK comment --file iapws.3.prep
NAME
    iapws - library for light and heavy water properties according to IAPWS.

LIBRARY
    iapws (-libiapws, -libiapws)

SYNOPSIS
    use iapws
    include "iapws.h"
    import pyiapws

DESCRIPTION
    Numerical implementation for reports:
        o R2-83
            o [x] Tc in H2O and D2O
            o [x] pc in H2O and D2O
            o [x] rhoc in H2O and D2O
        o G7-04 
            o [x] kH
            o [x] kD
        o R7-97
            o [x] Region 1
            o [ ] Region 2
            o [ ] Region 3
            o [x] Region 4
            o [ ] Region 5
        o R11-24:
            o [x] Kw

$INCLUDE ./fapi.txt

$INCLUDE ./capi.txt

$INCLUDE ./pyapi.txt

NOTES
    To use iapws within your fpm project, add the following to your fpm.toml file:

        [dependencies]
        iapws = { git="https://github.com/MilanSkocic/iapws.git" }

    o dp stands for double precision and it is an alias to real64
    from the iso_fortran_env module.
    o l => liquid
    o v => vapor
    o c => super critical
    o s => saturation
    o n => unknown

EXAMPLE
$INCLUDE ./example.txt

SEE ALSO
    codata(3), ciaaw(3)
$ENDBLOCK
module iapws
!! Main module for the IAPWS library.
use iapws__capi
use iapws__api

$IFDEF FPM_VERSION
$IMPORT FPM_VERSION
character(len=*), parameter, private :: v = '${FPM_VERSION}'
$ENDIF
character(len=:), allocatable, target :: vf
character(len=:), allocatable, target :: vc

!=======================================================================
! PUBLIC
!=======================================================================
public :: get_version, capi_get_version
public :: version, capi_version
!=======================================================================

contains
!=======================================================================
! GET_VERSION() - DEPRECATED
!=======================================================================
function get_version()result(fptr)
!! Get the version.
!! Deprecated. It will be removed in the next major release.
!! Use version() instead.
implicit none
character(len=:), pointer :: fptr  !! Fortran pointer to a string indicating the version..
fptr => version()
end function get_version
!-----------------------------------------------------------------------
function capi_get_version()bind(c, name='iapws_get_version')result(cptr)
!! C API.
type(c_ptr) :: cptr    !! C pointer to a string indicating the version.
cptr = capi_version()
end function capi_get_version
!=======================================================================


!=======================================================================
! VERSION()
!=======================================================================
function version()result(fptr)
!! Get the version.
character(len=:), pointer :: fptr !! Pointer to a string (=>version).
if(allocated(vf))then
    deallocate(vf)
endif
allocate(character(len=len(v)) :: vf)
vf = v
fptr => vf
end function version
!-----------------------------------------------------------------------
function capi_version()bind(C,name="iapws_version")result(cptr)
!! C API - Get the version
type(c_ptr) :: cptr !! C pointer to a string indicating the version.
character(len=:), pointer :: fptr
fptr => version()
if(allocated(vc))then
    deallocate(vc)
endif
allocate(character(len=len(fptr)+1) :: vc)
vc = fptr // c_null_char
cptr = c_loc(vc)
end function capi_version
!=======================================================================
end module
