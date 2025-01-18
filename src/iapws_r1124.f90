module iapws__r1124
    !! Module for IAPWS R11-24.
    use iapws__common
    implicit none
    private

    integer(int32), parameter :: n = 6       ! Ion coordination number
    real(dp), parameter :: Mw = 18.015268_dp ! g.mol^{-1}
    real(dp), parameter :: a0 = -0.702132_dp ! -
    real(dp), parameter :: a1 = +8681.05_dp  ! K
    real(dp), parameter :: a2 = -24145.1_dp  ! K^2(g.cm^{-3})^{-2/3}
    real(dp), parameter :: b0 = +0.813876_dp ! cm^3.g^{-1}
    real(dp), parameter :: b1 = -51.4471_dp  ! K cm^3 g^{-1}
    real(dp), parameter :: b2 = -0.469920_dp ! cm^6.g^{-2}
    real(dp), parameter :: Tlim1 = 273.15_dp ! K
    real(dp), parameter :: Tlim2 = 1273.15_dp! K

    public :: pKw

contains

pure elemental function Z(T, rhow)result(res)
    !! Empirical function in Bandura–Lvov model, g.cm^{-3}

    ! Arguments
    real(dp), intent(in) :: T     !! Temperature in K.
    real(dp), intent(in) :: rhow  !! Mass density, g.cm^{-3}

    ! Returns
    real(dp) :: res               !! Empirical value of temperature and water density

    res = rhow * exp(a0 + a1/T + (a2/T**2.0_dp)*rhow**(2.0_dp/3.0_dp))
end function

pure elemental function pKwG(T)result(res)
    !! Equilibrium constant of the ionization reaction in the ideal-gas state.

    ! Arguments
    real(dp), intent(in) :: T     !! Temperature in K.

    ! Returns
    real(dp) :: res
    res = 0.61415_dp + 48251.33_dp/T - 67707.93_dp/T**2.0_dp + 10102100.0_dp/T**3.0_dp

end function

pure elemental function pKw(T, rhow)result(res)
    !! Ionization constant of water.
    !! Validity range 273.13 K <= T <= 1273.15 K and 0 <= p <= 1000 MPa.

    ! Arguments
    real(dp), intent(in) :: T     !! Temperature in K.
    real(dp), intent(in) :: rhow  !! Mass density in g.cm^{-3}.

    ! Returns
    real(dp) :: res

    res = ieee_value(1.0_dp, ieee_quiet_nan)

    if((T>=Tlim1) .and. (T<=Tlim2))then
        res = -2.0_dp*n* ( &
        log10(1+Z(T, rhow)) - Z(T, rhow)/(Z(T, rhow)+1) * rhow * (b0 + b1/T + b2*rhow) &
        ) + pKwG(T) + 2.0_dp*log10(Mw/1000.0_dp) 
    endif
end function

end module iapws__r1124
