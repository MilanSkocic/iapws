module iapws__api
    !! API.
    use iapws__common
    use iapws__version
    use iapws__r283
    use iapws__g704
    use iapws__r797
    use iapws__r1124
    private

    
    character(len=:), allocatable, target :: version_f
    type(gas_type), allocatable, target :: f_gases(:)
    character(len=:), allocatable, target :: f_gases_str

    public :: get_version                                                       ! VERSION

    public :: kh, kd, gases, gases2, ngases, gas_type                           ! G704

    public :: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O                ! R283
    
    public :: r1_v, r1_u, r1_s, r1_h, r1_cp, r1_cv, r1_w                        ! R797
    public :: psat, Tsat                                                        ! R797

    public :: Kw                                                                ! R1124 
    public :: wp, wr, wph

contains

! ------------------------------------------------------------------------------
! VERSION
function get_version()result(fptr) 
    !! Return the version
    implicit none
    character(len=:), pointer :: fptr    !! Fortran pointer to a string indicating the version.

    if(allocated(version_f))then
        deallocate(version_f)
    endif
    allocate(character(len=len(version)) :: version_f)
    version_f = version
    fptr => version_f    
end function
! ------------------------------------------------------------------------------


! ------------------------------------------------------------------------------
! G704
pure subroutine kh(T, gas, heavywater, k)
    !! Compute the henry constant kH in MPa for a given temperature (x_2=1/kH). 
    implicit none
    
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
end subroutine

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

function gases(heavywater)result(list_gases)
    !! Returns the list of available gases.
    implicit none

    ! arguments
    integer(int32), intent(in) :: heavywater      !! Flag if D2O (1) is used or H2O(0).
    type(gas_type), pointer :: list_gases(:)      !! Available gases.
    
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

function gases2(heavywater)result(str_gases)
    !! Returns the available gases as a string.
    implicit none

    ! arguments
    integer(int32), intent(in) :: heavywater    !! Flag if D2O (1) is used or H2O(0).
    character(len=:), pointer :: str_gases      !! Available gases

    ! variables
    integer(int32) :: i, j, k, ngas
    type(gas_type), pointer :: f_gases_list(:)
    
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
! ------------------------------------------------------------------------------



! ------------------------------------------------------------------------------
! R797
pure subroutine psat(Ts, ps) 
    !! Compute the saturation pressure at temperature Ts (273.13 K <= Ts <= 647.096 K).

    real(dp), intent(in), contiguous :: Ts(:)  !! Saturation temperature in K.
    real(dp), intent(out), contiguous :: ps(:) !! Saturation pressure in MPa. Filled with nan if out of validity range.
    
    ps = r4_ps(Ts)
end subroutine

pure subroutine Tsat(ps, Ts) 
    !! Compute the saturation temperature at pressure ps (611.213 Pa <= ps <= 22.064 MPa).

    real(dp), intent(in), contiguous :: ps(:)  !! Saturation pressure in MPa.
    real(dp), intent(out), contiguous :: Ts(:) !! Saturation temperature in K. Filled with nan if out of validity range.

    Ts = r4_Ts(ps)
end subroutine

pure subroutine wp(p, T, prop, res) 
    !! Compute water properties at pressure p in MPa and temperature T in Kelvin.
    
    ! The adequate region is selected according to p and T.
    !
    ! Available properties:
    !     * v: specific volume in m3/kg
    !     * u: specific internal energy in kJ/kg
    !     * s: specific entropy in kJ/kg 
    !     * h: specific enthalpy in kJ/kg/K
    !     * cp: specific isobaric heat capacity in kJ/kg/K
    !     * cv: specific isochoric heat capacity in kJ/kg/K
    !     * w: speed of sound in m/s

    ! parameters
    real(dp), intent(in) :: p(:)                 !! Pressure in MPa.
    real(dp), intent(in) :: T(:)                 !! Pressure in K.
    character(len=*), intent(in) :: prop         !! Property (v, u, s, h, cp, cv, w)
    real(dp), intent(out) :: res(:)              !! Filled with NaN if no adequate region is found.

    ! variables
    logical :: is1r
    integer(int32) :: i
    integer(int32) :: regions(size(p))
    procedure(rai), pointer :: fptr

    res = ieee_value(1.0_dp, ieee_quiet_nan)

    regions = find_region(p, T)
    is1r = is1region(regions) 

    if(is1r .eqv. .true.)then
        fptr => get_r(regions(1))
        if(associated(fptr)) then
            call fptr(p, T, prop, res) 
        end if
    else
        do i=1, size(regions)
            fptr => get_r(regions(i))
            if(associated(fptr)) then
                call fptr(p, T, prop, res) 
            end if
        end do
    end if
end subroutine

pure subroutine wr(p, T, res) 
    !! Get the water region corresponding to p and T.

    ! parameters
    real(dp), intent(in)        :: p(:)           !! Pressure in MPa.
    real(dp), intent(in)        :: T(:)           !! Temperature in K.
    integer(int32), intent(out) :: res(:)         !! Region 1 to 5 if found or -1.

    res = find_region(p, T)
end subroutine

pure subroutine wph(p, T, res) 
    !! Get the water phase corresponding to p and T.
    
    ! parameters
    real(dp), intent(in)          :: p(:)     !! pressure in MPa.
    real(dp), intent(in)          :: T(:)     !! Temperature in K.
    character(len=1), intent(out) :: res(:)   !! Phases: l(liquid), v(VAPOR), c(SUPER CRITICAL), s(SATURATION), n(UNKNOWN).

    res = find_phase(p, T)
end subroutine
! ------------------------------------------------------------------------------


! ------------------------------------------------------------------------------
! R1124
pure subroutine Kw(T, rhow, k) 
    !! Compute the ionization constant of water Kw (273.13 K <= T <= 1273.15 K and 0 <= p <= 1000 MPa).

    ! arguments
    real(dp), intent(in) :: T(:)          !! Temperature in K.
    real(dp), intent(in) :: rhow(:)       !! Mass density in g.cm^{-3}.
    real(dp), intent(out) :: k(:)         !! Ionization constant. Filled with NaN if out of validity range. 

    k = 10**(-pKw(T, rhow))
end subroutine
! ------------------------------------------------------------------------------


end module iapws__api
