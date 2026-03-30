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
use iapws__r283, only: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O
use iapws__r283, only: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O
use iapws__g704, only: findgas_abc, findgas_efgh
use iapws__g704, only: abc_H2O, abc_D2O
use iapws__g704, only: f_kh_H2O, f_kh_D2O, f_kd_H2O, f_kd_D2O
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
public :: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O
public :: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O
public :: kh, capi_kh
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


!=======================================================================
! G704 - KH()
!=======================================================================
pure subroutine kh(T, gas, heavywater, k)
!! Compute the henry constant kH in MPa for a given temperature (x_2=1/kH). 
real(dp), intent(in), contiguous :: T(:)      !! Temperature in K.
character(len=*), intent(in) :: gas           !! Gas.
integer(int32), intent(in) :: heavywater      !! Flag if D2O (1) is used or H2O(0).
real(dp), intent(out), contiguous :: k(:)     !! Henry constant in MPa. Filled with NaNs if gas not found.

integer(int32) :: i

if(heavywater > 0)then
    i = findgas_abc(gas, abc_D2O)
    if(i==0)then
        k = ieee_value(1.0_dp, ieee_quiet_nan)
    else
        k =  f_kh_D2O(T, abc_D2O(i))
    endif
else
    i = findgas_abc(gas, abc_H2O)
    if(i==0)then
        k = ieee_value(1.0_dp, ieee_quiet_nan)
    else
        k = f_kh_H2O(T, abc_H2O(i))
    endif
endif
end subroutine kh
!-----------------------------------------------------------------------
subroutine capi_kh(T, gas, heavywater, k, size_gas, size_T)bind(C,name="iapws_g704_kh")
!! C API. 
integer(c_int), intent(in), value :: size_gas !! Size of the gas string.
integer(c_size_t), intent(in), value :: size_T !! Size of T and k.
real(c_double), intent(in) :: T(size_T) !! Temperature in °C.
type(c_ptr), intent(in), value :: gas !! Gas.
integer(c_int), intent(in), value :: heavywater !! Flag if D2O (1) is used or H2O(0).
real(c_double), intent(inout) :: k(size_T) !! Henry constant. Filled with NaNs if gas not found.

character, pointer, dimension(:) :: c2f_gas
character(len=size_gas) :: f_gas
integer(int32) :: i

call c_f_pointer(gas, c2f_gas, shape=[size_gas])

do i=1, size_gas
    f_gas(i:i) = c2f_gas(i)
enddo
call kh(T, f_gas, heavywater, k)
end subroutine capi_kh
!=======================================================================
end module
