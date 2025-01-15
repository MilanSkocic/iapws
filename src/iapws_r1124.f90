module iapws__g704
    !! Module for IAPWS R11-24.
    use iapws__common
    implicit none
    private

integer(int32), parameter :: n = 6    ! Ion coordination number
real(dp), parameter :: Mw = 18.015268 ! g.mol^{-1}
real(dp), parameter :: a0 = -0.702132 ! -
real(dp), parameter :: a1 = +8681.05  ! K
real(dp), parameter :: a2 = -24145.1  ! K^2(g.cm^{-3})^{-2/3}
real(dp), parameter :: b0 = +0.813876 ! cm^3.g^{-1}
real(dp), parameter :: b1 = -51.4471  ! K cm^3 g^{-1}
real(dp), parameter :: b2 = -0.469920 ! cm^6.g^{-2}

contains

pure elemental Z(T, rhow)result(res)
    !! Empirical function in Bandura–Lvov model, g.cm^{-3}

    !! Arguments
    real(dp), intent(in) :: T     !! Temperature in K.
    real(dp), intent(in) :: rhow  !! Mass density, g.cm^{-3}

    !! Returns
    real(dp) :: res               !! Empirical value of temperature and water density

    Z = rhow * exp(a0 + a1/T + a2/T**2.0_dp*rhow**(2.0_dp/3.0_dp))
end function

end module iapws__r1124
