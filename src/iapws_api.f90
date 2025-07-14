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
    character(len=:), pointer :: fptr    !! Fortran pointer to a string indicating the version..

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

! ------------------------------------------------------------------------------


! ------------------------------------------------------------------------------
! R797
pure subroutine psat(Ts, ps)
    !! Compute the saturation pressure at temperature Ts. 
    !! Validity range 273.13 K <= Ts <= 647.096 K.

    real(dp), intent(in), contiguous :: Ts(:)  !! Saturation temperature in K.
    real(dp), intent(out), contiguous :: ps(:) !! Saturation pressure in MPa. Filled with nan if out of validity range.
    
    ps = r4_ps(Ts)
end subroutine

pure subroutine Tsat(ps, Ts)
    !! Compute the saturation temperature at pressure ps.
    !! Validity range 611.213 Pa <= ps <= 22.064 MPa.

    real(dp), intent(in), contiguous :: ps(:)  !! Saturation pressure in MPa.
    real(dp), intent(out), contiguous :: Ts(:) !! Saturation temperature in K. Filled with nan if out of validity range.

    Ts = r4_Ts(ps)
end subroutine

pure subroutine wp(p, T, prop, res)
    !! Compute water properties at pressure p in MPa and temperature T in Kelvin.
    !! The adequate region is selected according to p and T.
    !!
    !! Available properties:
    !!     * v: specific volume in m3/kg
    !!     * u: specific internal energy in kJ/kg
    !!     * s: specific entropy in kJ/kg 
    !!     * h: specific enthalpy in kJ/kg/K
    !!     * cp: specific isobaric heat capacity in kJ/kg/K
    !!     * cv: specific isochoric heat capacity in kJ/kg/K
    !!     * w: speed of sound in m/s

    ! parameters
    real(dp), intent(in) :: p(:)                 !! Pressure in MPa.
    real(dp), intent(in) :: T(:)                 !! Pressure in K.
    character(len=*), intent(in) :: prop         !! Property
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
    !! Regions 1 to 5 or -1 when not found.

    ! parameters
    real(dp), intent(in)        :: p(:)           !! Pressure in MPa.
    real(dp), intent(in)        :: T(:)           !! Temperature in K.
    integer(int32), intent(out) :: res(:)         !! Region (1-5)

    res = find_region(p, T)
end subroutine

pure subroutine wph(p, T, res)
    !! Get the water phase corresponding to p and T.
    !! Phases: l(liquid), v(VAPOR), c(SUPER CRITICAL), s(SATURATION), n(UNKNOWN).
    
    ! parameters
    real(dp), intent(in)          :: p(:)     !! pressure in MPa.
    real(dp), intent(in)          :: T(:)     !! Temperature in K.
    character(len=1), intent(out) :: res(:)   !! Phase (l, v, c, s, n)

    res = find_phase(p, T)
end subroutine
! ------------------------------------------------------------------------------


! ------------------------------------------------------------------------------
! R1124
pure subroutine Kw(T, rhow, k)
    !! Compute the ionization constant of water Kw.
    !! Validity range 273.13 K <= T <= 1273.15 K and 0 <= p <= 1000 MPa.

    ! arguments
    real(dp), intent(in) :: T(:)          !! Temperature in K.
    real(dp), intent(in) :: rhow(:)       !! Mass density in g.cm^{-3}.
    real(dp), intent(out) :: k(:)         !! Ionization constant. Filled with NaN if out of validity range. 

    k = 10**(-pKw(T, rhow))
end subroutine
! ------------------------------------------------------------------------------


end module iapws__api
