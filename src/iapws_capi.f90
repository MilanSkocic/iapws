module iapws__capi
    !! C API.
    use iso_c_binding, only: c_double, c_int, c_ptr, c_f_pointer, c_char, c_size_t, c_null_char, c_loc
    use iapws__common
    use iapws__api
    implicit none
    
    
    character(len=:), allocatable, target :: version_c
    
    type, bind(C) :: c_char_p
        type(c_ptr) :: p
    end type
    type :: cgas_type
        character(kind=c_char, len=1), allocatable :: gas(:)
    end type
    type(cgas_type), allocatable, target :: c_gases(:)
    type(c_char_p), allocatable, target :: char_pp(:)
    character(len=:), allocatable, target :: c_gases_str

    ! ------------------------------------------------------------------------------
    ! R283
    real(c_double), protected, bind(C, name="iapws_r283_Tc_H2O") :: capi_Tc_H2O = Tc_H2O !! Critical temperature for H2O in K
    real(c_double), protected, bind(C, name="iapws_r283_Tc_D2O") :: capi_Tc_D2O = Tc_D2O !! Critical temperature for D2O in K

    real(c_double), protected, bind(C, name="iapws_r283_pc_H2O") :: capi_pc_H2O = pc_H2O !! Critical pressure for H2O in MPa
    real(c_double), protected, bind(C, name="iapws_r283_pc_D2O") :: capi_pc_D2O = pc_D2O !! Critical pressure for D2O in MPa

    real(c_double), protected, bind(C, name="iapws_r283_rhoc_H2O") :: capi_rhoc_H2O = rhoc_H2O !! Critical density for H2O in kg.m-3
    real(c_double), protected, bind(C, name="iapws_r283_rhoc_D2O") :: capi_rhoc_D2O = rhoc_D2O !! Critical density for D2O in kg.m-3
    ! ------------------------------------------------------------------------------

    public :: capi_get_version                                                                     !! VERSION

    public :: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O     !! R283
    
    public :: capi_kh, capi_kd, capi_ngases, capi_gases                                            !!G704

    public :: capi_psat, capi_Tsat, capi_wp                                                                !! R797


contains


! ------------------------------------------------------------------------------
! VERSION 
function capi_get_version()bind(c,name="iapws_get_version")result(cptr)
    !! C API
    implicit none
    
    ! Returns   
    type(c_ptr) :: cptr !! Pointer to version string.

    character(len=:), pointer :: fptr
    fptr => get_version() 

    if(allocated(version_c))then
        deallocate(version_c)
    endif
    allocate(character(len=len(fptr)+1) :: version_c)

    version_c = fptr // c_null_char
    cptr = c_loc(version_c)
end function
! ------------------------------------------------------------------------------



! ------------------------------------------------------------------------------
! G704
subroutine capi_kh(T, gas, heavywater, k, size_gas, size_T)bind(C,name="iapws_g704_kh")
    !! C API. 
    implicit none
    
    ! arguments
    integer(c_int), intent(in), value :: size_gas !! Size of the gas string.
    integer(c_size_t), intent(in), value :: size_T !! Size of T and k.
    real(c_double), intent(in) :: T(size_T) !! Temperature in °C.
    type(c_ptr), intent(in), value :: gas !! Gas.
    integer(c_int), intent(in), value :: heavywater !! Flag if D2O (1) is used or H2O(0).
    real(c_double), intent(inout) :: k(size_T) !! Henry constant. Filled with NaNs if gas not found.
    
    ! variables
    character, pointer, dimension(:) :: c2f_gas
    character(len=size_gas) :: f_gas
    integer(int32) :: i

    call c_f_pointer(gas, c2f_gas, shape=[size_gas])

    do i=1, size_gas
        f_gas(i:i) = c2f_gas(i)
    enddo
    call kh(T, f_gas, heavywater, k)    
end subroutine

subroutine capi_kd(T, gas, heavywater, k, size_gas, size_T)bind(C,name="iapws_g704_kd")
    !! C API.
    implicit none
    
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

    type(gas_type), pointer :: f_gases(:) => null()
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
! ------------------------------------------------------------------------------



! ------------------------------------------------------------------------------
! R797
subroutine capi_psat(N, Ts, ps)bind(C, name="iapws_r797_psat")
    !! C API.

    integer(c_size_t), intent(in), value :: N     !! Size of Ts and ps.
    real(c_double), intent(in) :: Ts(N)           !! Saturation temperature in K.
    real(c_double), intent(out) :: ps(N)          !! Saturation pressure in MPa. Filled with nan if out of validity range.

    call psat(Ts, ps)

end subroutine

subroutine capi_Tsat(N, ps, Ts)bind(C, name="iapws_r797_Tsat")
    !! C API.
    
    integer(c_size_t), intent(in), value :: N     !! Size of ps and Ts.
    real(c_double), intent(in) ::   ps(N)         !! Saturation pressure in MPa.
    real(c_double), intent(out) ::  Ts(N)         !! Saturation temperature in K. Filled with nan if out of validity range.
    
    call Tsat(ps, Ts)
end subroutine

subroutine capi_wp(p, T, prop, res, N, len)bind(C, name="iapws_r797_wp")
    !! C API.
    
    !! Available properties:
    !!     * v: specific volume in m3/kg
    !!     * u: specific internal energy in kJ/kg
    !!     * s: specific entropy in kJ/kg 
    !!     * h: specific enthalpy in kJ/kg/K
    !!     * cp: specific isobaric heat capacity in kJ/kg/K
    !!     * cv: specific isochoric heat capacity in kJ/kg/K
    !!     * w: speed of sound in m/s
   
    ! parameters
    integer(c_int), intent(in), value    :: len         !! Size of the prop string.
    integer(c_size_t), intent(in), value :: N           !! Size of T and p.
    real(c_double), intent(in)           :: p(N)        !! Pressure in MPa.
    real(c_double), intent(in)           :: T(N)        !! Temperature in K.
    type(c_ptr), intent(in), value       :: prop        !! Water property.
    real(c_double), intent(out)          :: res(N)      !! Result. Filled with NaNs if gas not found.
    
    ! variables
    character, pointer, dimension(:) :: cprop
    character(len=len) :: fprop
    integer(int32) :: i

    call c_f_pointer(prop, cprop, shape=[len])

    do i=1, len
        fprop(i:i) = cprop(i)
    enddo

    call wp(p, T, fprop, res)
end subroutine

subroutine capi_wr(p, T, res, N)bind(C, name="iapws_r797_wr")
    !! C API.

    ! parameters
    integer(c_size_t), intent(in), value :: N           !! Size of T and p.
    real(c_double), intent(in)           :: p(N)        !! Pressure in MPa.
    real(c_double), intent(in)           :: T(N)        !! Temperature in K.
    integer(c_int), intent(out)          :: res(N)      !! Regions.

    call wr(p, T, res)
end subroutine

subroutine capi_wph(p, T, res, N)bind(C, name="iapws_r797_wph")
    !! C API.

    ! parameters
    integer(c_size_t), intent(in), value          :: N           !! Size of T and p.
    real(c_double), intent(in)                    :: p(N)        !! Pressure in MPa.
    real(c_double), intent(in)                    :: T(N)        !! Temperature in K.
    character(len=1, kind=c_char), intent(out)     :: res(N)      !! Regions.

    call wph(p, T, res)
end subroutine
! ------------------------------------------------------------------------------


! ------------------------------------------------------------------------------
! R1124
subroutine capi_Kw(N, T, rhow, k)bind(C, name="iapws_r1124_Kw")
    !! C API.

    ! arguments
    integer(c_size_t), intent(in), value :: N     !! Size of T, rhow and k.
    real(c_double), intent(in) :: T(N)                  !! Temperature in K.
    real(c_double), intent(in) :: rhow(N)               !! Mass density in g.cm^{-3}.
    real(c_double), intent(out) :: k(N)                 !! Ionization constant. Filled with NaN if out of validity range. 

    call Kw(T, rhow, k)
end subroutine
! ------------------------------------------------------------------------------

end module iapws__capi
