module iapws__api
    !! API.
    !! See [specs](../page/specs/api.html).
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
    
contains

! ------------------------------------------------------------------------------
! VERSION
function get_version()result(fptr)
    !! Get the version
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

pure subroutine waterproperty(p, T, prop, res)
    !! Compute water properties at pressure p in MPa and temperature T in Kelvin.
    !! The adequate region is selected according to p and T.
    !!
    !! Available properties:
    !!     * v: specific volume
    !!     * u: specific internal energy
    !!     * s: specific entropy
    !!     * h: specific enthalpy
    !!     * cp: specific isobaric heat capacity
    !!     * cv: specific isochoric heat capacity
    !!     * w: speed of sound

    ! parameters
    real(dp), intent(in) :: p(:)                 !! Pressure in MPa.
    real(dp), intent(in) :: T(:)                 !! Pressure in K.
    character(len=*), intent(in) :: prop         !! Property
    real(dp), intent(out) :: res(:)              !! Filled with NaN if no adequate region is found.

    ! variables
    integer(int32) :: regions(size(p))

    res = ieee_value(1.0_dp, ieee_quiet_nan)
    ! regions = find_region(p, T)

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
    real(dp), intent(out) :: k(:)      !! Ionization constant. Filled with NaN if out of validity range. 

    k = 10**(-pKw(T, rhow))
    
end subroutine
! ------------------------------------------------------------------------------


end module iapws__api
