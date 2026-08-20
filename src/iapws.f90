! SPDX-License-Identifier: MIT

!=======================================================================
! MODULE: IAPWS
!=======================================================================
module iapws
!! Main module for the IAPWS library.
use iapws__r283, only: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O
use iapws__r283, only: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O
use iapws__g704, only: findgas_abc, findgas_efgh
use iapws__g704, only: abc_H2O, abc_D2O, efgh_H2O, efgh_D2O
use iapws__g704, only: f_kh_H2O, f_kh_D2O, f_kd_H2O, f_kd_D2O
use iapws__r1124, only: pkw
use iapws__r797, only: r4_Ts, r4_ps
use iapws__capi
use iapws__api

character(len=*), parameter, private :: v = '0.7.1'
character(len=:), allocatable, target :: vf
character(len=:), allocatable, target :: vc


!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
! PUBLIC
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
public :: get_version, capi_get_version
public :: version, capi_version
public :: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O
public :: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O
public :: kh, capi_kh, kd, capi_kd, Kw, capi_Kw
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

contains
!-----------------------------------------------------------------------
! GET_VERSION() - DEPRECATED
!-----------------------------------------------------------------------
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
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! FUNCTION: VERSION()
!-----------------------------------------------------------------------
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
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: G704 - KH()
!-----------------------------------------------------------------------
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
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: G704 - KD()
!-----------------------------------------------------------------------
pure subroutine kd(T, gas, heavywater, k)
!! Compute the vapor-liquid constant kd for a given temperature (kd=y_2/x_2).
implicit none

real(dp), intent(in), contiguous :: T(:)             !! Temperature in K.
character(len=*), intent(in) :: gas                  !! Gas.
integer(int32), intent(in) :: heavywater             !! Flag if D2O (1) is used or H2O(0).
real(dp), intent(out), contiguous :: k(:)            !! Vapor-liquid constant (adimensional). Filled with NaNs if gas not found.

integer(int32) :: i

if(heavywater > 0)then
    i = findgas_efgh(gas, efgh_D2O)
    if(i==0)then
        k = ieee_value(1.0_dp, ieee_quiet_nan)
    else
        k =  f_kd_D2O(T, efgh_D2O(i))
    endif
else
    i = findgas_efgh(gas, efgh_H2O)
    if(i==0)then
        k = ieee_value(1.0_dp, ieee_quiet_nan)
    else
        k = f_kd_H2O(T, efgh_H2O(i))
    endif
endif
end subroutine
! ----------------------------------------------------------------------
subroutine capi_kd(T, gas, heavywater, k, size_gas, size_T)bind(C,name="iapws_g704_kd")
!! C API.
! arguments
integer(c_size_t), intent(in), value :: size_T !! Size of T and k.
integer(c_int), intent(in), value :: size_gas !! Size of the gas string.
real(c_double), intent(in) :: T(size_T) !! Temperature in °C.
type(c_ptr), intent(in), value :: gas !! Gas.
integer(c_int), intent(in), value :: heavywater  !! Flag if D2O (1) is used or H2O(0).
real(c_double), intent(inout) :: k(size_T) !! Vapor-liquid constant. Filled with NaNs if gas not found.

! variables
character, pointer, dimension(:) :: c2f_gas
character(len=size_gas) :: f_gas
integer(int32) :: i

call c_f_pointer(gas, c2f_gas, shape=[size_gas])

do i=1, size_gas
    f_gas(i:i) = c2f_gas(i)
enddo
call kd(T, f_gas, heavywater, k)    
end subroutine
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: R797 - PSAT()
!-----------------------------------------------------------------------
pure subroutine psat(Ts, ps) 
!! Compute the saturation pressure at temperature Ts (273.13 K <= Ts <= 647.096 K).
real(dp), intent(in), contiguous :: Ts(:)  !! Saturation temperature in K.
real(dp), intent(out), contiguous :: ps(:) !! Saturation pressure in MPa. Filled with nan if out of validity range.
ps = r4_ps(Ts)
end subroutine
! ----------------------------------------------------------------------
subroutine capi_psat(N, Ts, ps)bind(C, name="iapws_r797_psat")
!! C API.
integer(c_size_t), intent(in), value :: N     !! Size of Ts and ps.
real(c_double), intent(in) :: Ts(N)           !! Saturation temperature in K.
real(c_double), intent(out) :: ps(N)          !! Saturation pressure in MPa. Filled with nan if out of validity range.
call psat(Ts, ps)
end subroutine
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: R797 - TSAT()
!-----------------------------------------------------------------------
pure subroutine Tsat(ps, Ts) 
!! Compute the saturation temperature at pressure ps (611.213 Pa <= ps <= 22.064 MPa).
real(dp), intent(in), contiguous :: ps(:)  !! Saturation pressure in MPa.
real(dp), intent(out), contiguous :: Ts(:) !! Saturation temperature in K. Filled with nan if out of validity range.
Ts = r4_Ts(ps)
end subroutine
! ----------------------------------------------------------------------
subroutine capi_Tsat(N, ps, Ts)bind(C, name="iapws_r797_Tsat")
!! C API.
integer(c_size_t), intent(in), value :: N     !! Size of ps and Ts.
real(c_double), intent(in) ::   ps(N)         !! Saturation pressure in MPa.
real(c_double), intent(out) ::  Ts(N)         !! Saturation temperature in K. Filled with nan if out of validity range.
call Tsat(ps, Ts)
end subroutine
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: R1124 - KW()
!-----------------------------------------------------------------------
pure subroutine Kw(T, rhow, k) 
!! Compute the ionization constant of water Kw (273.13 K <= T <= 1273.15 K and 0 <= p <= 1000 MPa).
! arguments
real(dp), intent(in) :: T(:)          !! Temperature in K.
real(dp), intent(in) :: rhow(:)       !! Mass density in g.cm^{-3}.
real(dp), intent(out) :: k(:)         !! Ionization constant. Filled with NaN if out of validity range. 

k = 10**(-pKw(T, rhow))
end subroutine
! ----------------------------------------------------------------------
subroutine capi_Kw(N, T, rhow, k)bind(C, name="iapws_r1124_Kw")
!! C API.
! arguments
integer(c_size_t), intent(in), value :: N  !! Size of T, rhow and k.
real(c_double), intent(in) :: T(N)         !! Temperature in K.
real(c_double), intent(in) :: rhow(N)      !! Mass density in g.cm^{-3}.
real(c_double), intent(out) :: k(N)        !! Ionization constant. Filled with NaN if out of validity range. 

call Kw(T, rhow, k)
end subroutine
!-----------------------------------------------------------------------

end module
