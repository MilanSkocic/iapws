! SPDX-License-Identifier: MIT

!=======================================================================
! MODULE: IAPWS
!=======================================================================
module iapws
!! Main module for the IAPWS library.
use iapws__r283, only: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O
use iapws__r283, only: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O
use iapws__g704, only: findgas_abc, findgas_efgh, ngas_H2O, ngas_D2O
use iapws__g704, only: abc_H2O, abc_D2O, efgh_H2O, efgh_D2O
use iapws__g704, only: f_kh_H2O, f_kh_D2O, f_kd_H2O, f_kd_D2O
use iapws__r1124, only: pkw
use iapws__r797, only: r4_Ts, r4_ps
use iapws__capi
use iapws__api
implicit none(type,external)
private


!***********************************************************************
! DERIVED TYPE: GAS_T
!***********************************************************************
!{{{
!}}}
!***********************************************************************

!***********************************************************************
! DERIVED TYPRE: gas_t + c_ptr_t + cgas_t
!***********************************************************************
!{{{
type :: gas_t
character(len=:), allocatable :: gas !! Gas
end type gas_t

type, bind(C) :: c_ptr_t
type(c_ptr) :: p
end type

type :: cgas_t
character(kind=c_char, len=1), allocatable :: gas(:)
end type
!}}}
!***********************************************************************

!-----------------------------------------------------------------------
! MODULE variables
!-----------------------------------------------------------------------
!{{{
type(gas_t), allocatable, target :: f_gases(:)
character(len=:), allocatable, target :: f_gases_str
type(cgas_t), allocatable, target :: c_gases(:)
type(c_ptr_t), allocatable, target :: char_pp(:)
character(len=:), allocatable, target :: c_gases_str
character(len=*), parameter :: v = '0.7.1'
character(len=:), allocatable, target :: vf
character(len=:), allocatable, target :: vc
!}}}
!-----------------------------------------------------------------------


!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
! PUBLIC
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!{{{
public :: get_version, capi_get_version
public :: version, capi_version
public :: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O
public :: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O
public :: kh, capi_kh, kd, capi_kd, Kw, capi_Kw
public :: Tsat, capi_Tsat, psat, capi_psat

public :: gases, gases2, ngases, gas_t                     ! G704
public :: r1_v, r1_u, r1_s, r1_h, r1_cp, r1_cv, r1_w            ! R797
public :: wp, wr, wph


public :: capi_ngases, capi_gases                !!G704
public :: capi_wp                !! R797
!}}}
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

contains
!-----------------------------------------------------------------------
! GET_VERSION() - DEPRECATED
!-----------------------------------------------------------------------
!{{{
function get_version()result(fptr)
!! Get the version.
!! Deprecated. It will be removed in the next major release.
!! Use version() instead.
implicit none
character(len=:), pointer :: fptr  !! Fortran pointer to a string indicating the version..
fptr => version()
end function get_version
!}}}
!-----------------------------------------------------------------------
!{{{
function capi_get_version()bind(c, name='iapws_get_version')result(cptr)
!! C API.
type(c_ptr) :: cptr    !! C pointer to a string indicating the version.
cptr = capi_version()
end function capi_get_version
!}}}
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! FUNCTION: VERSION()
!-----------------------------------------------------------------------
!{{{
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
!}}}
!-----------------------------------------------------------------------
!{{{
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
!}}}
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! FUNCTION: G704 - NAGSES()
!-----------------------------------------------------------------------
!{{{
pure function ngases(heavywater)result(n)
!! Returns the number of gases.
implicit none

integer(int32), intent(in) :: heavywater !! Flag if D2O (1) is used or H2O(0).
integer(int32) :: n                      !! Number of gases.

if(heavywater > 0)then
    n = ngas_D2O
else
    n = ngas_H2O
endif
end function
!-----------------------------------------------------------------------
function capi_ngases(heavywater)bind(C, name="iapws_g704_ngases")result(n)
    !! C API.
    implicit none
    
    ! arguments
    integer(c_int), intent(in), value :: heavywater
        !! Flag if D2O (1) is used or H2O(0).
    integer(c_int) :: n
        !! Number of gases.

    n = ngases(heavywater)
end function
!}}}
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! FUNCTION: G704 - GASES()
!-----------------------------------------------------------------------
!{{{
function gases(heavywater)result(list_gases)
!! Returns the list of available gases.
implicit none

! arguments
integer(int32), intent(in) :: heavywater      !! Flag if D2O (1) is used or H2O(0).
type(gas_t), pointer :: list_gases(:)      !! Available gases.

! variables
integer(int32) :: i, n

if(allocated(f_gases))then
    deallocate(f_gases)
endif

if(heavywater > 0)then
    allocate(f_gases(ngas_D2O))
    do i=1, ngas_D2O
        if(allocated(f_gases(i)%gas))then
            deallocate(f_gases(i)%gas)
        endif
        n = len(trim(abc_D2O(i)%gas))
        allocate(character(len=n) :: f_gases(i)%gas)
        f_gases(i)%gas = trim(abc_D2O(i)%gas)
    enddo
else
    allocate(f_gases(ngas_H2O))
    do i=1, ngas_H2O
        if(allocated(f_gases(i)%gas))then
            deallocate(f_gases(i)%gas)
        endif
        n = len(trim(abc_H2O(i)%gas))
        allocate(character(len=n) :: f_gases(i)%gas)
        f_gases(i)%gas = trim(abc_H2O(i)%gas)
    enddo
endif
list_gases => f_gases
end function
!-----------------------------------------------------------------------
function capi_gases(heavywater)bind(C, name="iapws_g704_gases")result(list_gases)
!! C API.
implicit none

! arguments
integer(c_int), intent(in), value :: heavywater
    !! Flag if D2O (1) is used or H2O(0).
type(c_ptr) :: list_gases
    !! Available gases.

! variables
integer(int32) :: i, j, ngas, n

type(gas_t), pointer :: f_gases(:) => null()
f_gases => gases(heavywater)
ngas = size(f_gases)

if(allocated(c_gases))then
    deallocate(c_gases)
endif
allocate(c_gases(ngas))

if(allocated(char_pp))then
    deallocate(char_pp)
endif
allocate(char_pp(ngas))

do i=1, ngas
    if(allocated(c_gases(i)%gas))then
        deallocate(c_gases(i)%gas)
    endif
    n = len(f_gases(i)%gas)
    allocate(c_gases(i)%gas(n+1))
    do j=1, n
        c_gases(i)%gas(j) = f_gases(i)%gas(j:j)
    enddo
    c_gases(i)%gas(n+1) = c_null_char
    char_pp(i)%p = c_loc(c_gases(i)%gas)
enddo
list_gases = c_loc(char_pp)
end function
!}}}
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! FUNCTION: G704 - GASES2()
!-----------------------------------------------------------------------
!{{{
function gases2(heavywater)result(str_gases)
!! Returns the available gases as a string.
implicit none

! arguments
integer(int32), intent(in) :: heavywater    !! Flag if D2O (1) is used or H2O(0).
character(len=:), pointer :: str_gases      !! Available gases

! variables
integer(int32) :: i, j, k, ngas
type(gas_t), pointer :: f_gases_list(:)

f_gases_list => gases(heavywater)
ngas = size(f_gases_list)

k = 0
do i=1, ngas
    k = k + len(f_gases_list(i)%gas)
enddo

if(allocated(f_gases_str))then
    deallocate(f_gases_str)
endif
allocate(character(len=k+ngas) :: f_gases_str)

i = 1
j = 1
k = 1
do i=1, ngas
    do j=1, len(f_gases_list(i)%gas)
        f_gases_str(k:k) = f_gases_list(i)%gas(j:j)
        k = k + 1
    enddo
    f_gases_str(k:k) = ","
    k = k + 1
enddo
f_gases_str(len(f_gases_str):len(f_gases_str)) = ""
str_gases => f_gases_str
end function
!-----------------------------------------------------------------------
function capi_gases2(heavywater)bind(C, name="iapws_g704_gases2")result(str_gases)
!! C API.
implicit none

! arguments
integer(c_int), intent(in), value :: heavywater
    !! Flag if D2O (1) is used or H2O(0).
type(c_ptr) :: str_gases
    !! Available gases.

! variables
character(len=:), pointer :: f_gases_str => null()
f_gases_str => gases2(heavywater)

if(allocated(c_gases_str))then
    deallocate(c_gases_str)
endif
allocate(character(len=len(f_gases_str)) :: c_gases_str)

c_gases_str = f_gases_str
c_gases_str(len(f_gases_str):len(f_gases_str)) = c_null_char

str_gases = c_loc(c_gases_str)
end function
!}}}
!-------------------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: G704 - KH()
!-----------------------------------------------------------------------
!{{{
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
!}}}
!-----------------------------------------------------------------------
!{{{
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
!}}}
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: G704 - KD()
!-----------------------------------------------------------------------
!{{{
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
!}}}
! ----------------------------------------------------------------------
!{{{
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
!}}}
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: R797 - PSAT()
!-----------------------------------------------------------------------
!{{{
pure subroutine psat(Ts, ps) 
!! Compute the saturation pressure at temperature Ts (273.13 K <= Ts <= 647.096 K).
real(dp), intent(in), contiguous :: Ts(:)  !! Saturation temperature in K.
real(dp), intent(out), contiguous :: ps(:) !! Saturation pressure in MPa. Filled with nan if out of validity range.
ps = r4_ps(Ts)
end subroutine
!}}}
! ----------------------------------------------------------------------
!{{{
subroutine capi_psat(N, Ts, ps)bind(C, name="iapws_r797_psat")
!! C API.
integer(c_size_t), intent(in), value :: N     !! Size of Ts and ps.
real(c_double), intent(in) :: Ts(N)           !! Saturation temperature in K.
real(c_double), intent(out) :: ps(N)          !! Saturation pressure in MPa. Filled with nan if out of validity range.
call psat(Ts, ps)
end subroutine
!}}}
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: R797 - TSAT()
!-----------------------------------------------------------------------
!{{{
pure subroutine Tsat(ps, Ts) 
!! Compute the saturation temperature at pressure ps (611.213 Pa <= ps <= 22.064 MPa).
real(dp), intent(in), contiguous :: ps(:)  !! Saturation pressure in MPa.
real(dp), intent(out), contiguous :: Ts(:) !! Saturation temperature in K. Filled with nan if out of validity range.
Ts = r4_Ts(ps)
end subroutine
!}}}
! ----------------------------------------------------------------------
!{{{
subroutine capi_Tsat(N, ps, Ts)bind(C, name="iapws_r797_Tsat")
!! C API.
integer(c_size_t), intent(in), value :: N     !! Size of ps and Ts.
real(c_double), intent(in) ::   ps(N)         !! Saturation pressure in MPa.
real(c_double), intent(out) ::  Ts(N)         !! Saturation temperature in K. Filled with nan if out of validity range.
call Tsat(ps, Ts)
end subroutine
!}}}
!-----------------------------------------------------------------------


!-----------------------------------------------------------------------
! SUBROUTINE: R1124 - KW()
!-----------------------------------------------------------------------
!{{{
pure subroutine Kw(T, rhow, k) 
!! Compute the ionization constant of water Kw (273.13 K <= T <= 1273.15 K and 0 <= p <= 1000 MPa).
! arguments
real(dp), intent(in) :: T(:)          !! Temperature in K.
real(dp), intent(in) :: rhow(:)       !! Mass density in g.cm^{-3}.
real(dp), intent(out) :: k(:)         !! Ionization constant. Filled with NaN if out of validity range. 

k = 10**(-pKw(T, rhow))
end subroutine
!}}}
! ----------------------------------------------------------------------
!{{{
subroutine capi_Kw(N, T, rhow, k)bind(C, name="iapws_r1124_Kw")
!! C API.
! arguments
integer(c_size_t), intent(in), value :: N  !! Size of T, rhow and k.
real(c_double), intent(in) :: T(N)         !! Temperature in K.
real(c_double), intent(in) :: rhow(N)      !! Mass density in g.cm^{-3}.
real(c_double), intent(out) :: k(N)        !! Ionization constant. Filled with NaN if out of validity range. 

call Kw(T, rhow, k)
end subroutine
!}}}
!-----------------------------------------------------------------------

end module
