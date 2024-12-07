module iapws__r797
    !! Module for IAPWS R7-97: Not fully implemented - under development.
    use stdlib_kinds, only: dp
    use ieee_arithmetic
    use iapws__r283, only: Tc_H2O, pc_H2O, rhoc_H2O
    implicit none
    private

    public :: psat, Tsat, r1_v

    
real(dp), parameter :: T_KELVIN = 273.15_dp !! Parameters from IAPWS R7-97
real(dp), parameter :: Tc = Tc_H2O          !! critical temperature of water in K
real(dp), parameter :: pc = pc_H2O          !! critical pressure of the water in MPa
real(dp), parameter :: rhoc = rhoc_H2O      !! critical density of the water in kg.m-3.

real(dp), parameter :: R = 0.461526_dp      !! Specific gas constant 0.461 526 kJ.kg-1.K-1



! Region 1
!--------------------------------------------------------------------------------------------------------------------------------
real(dp), parameter :: r1_ps = 16.53_dp !! p* in MPa.
real(dp), parameter :: r1_Ts = 1386.0_dp !! T* in K.

real(dp), target :: r1_IJn_g(34, 3) = transpose(reshape([&
  +0.0_dp,  -2.0_dp, +0.14632971213167d0,   &
  +0.0_dp,  -1.0_dp, -0.84548187169114d0,   &
  +0.0_dp,   0.0_dp, -0.37563603672040d1,   &
  +0.0_dp,  +1.0_dp, +0.33855169168385d1,   &
  +0.0_dp,  +2.0_dp, -0.95791963387872d0,   &
  +0.0_dp,  +3.0_dp, +0.15772038513228d0,   &
  +0.0_dp,  +4.0_dp, -0.16616417199501d-1,  &
  +0.0_dp,  +5.0_dp, +0.81214629983568d-3,  &
  +1.0_dp,  -9.0_dp, +0.28319080123804d-3,  &
  +1.0_dp,  -7.0_dp, -0.60706301565874d-3,  &
  +1.0_dp,  -1.0_dp, -0.18990068218419d-1,  &
  +1.0_dp,   0.0_dp, -0.32529748770505d-1,  &
  +1.0_dp,  +1.0_dp, -0.21841717175414d-1,  &
  +1.0_dp,  +3.0_dp, -0.52838357969930d-4,  &
  +2.0_dp,  -3.0_dp, -0.47184321073267d-3,  &
  +2.0_dp,   0.0_dp, -0.30001780793026d-3,  &
  +2.0_dp,  +1.0_dp, +0.47661393906987d-4,  &
  +2.0_dp,  +3.0_dp, -0.44141845330846d-5,  &
  +2.0_dp, +17.0_dp, -0.72694996297594d-15, &
  +3.0_dp,  -4.0_dp, -0.31679644845054d-4,  &
  +3.0_dp,   0.0_dp, -0.28270797985312d-5,  &
  +3.0_dp,  +6.0_dp, -0.85205128120103d-9,  &
  +4.0_dp,  -5.0_dp, -0.22425281908000d-5,  &
  +4.0_dp,  -2.0_dp, -0.65171222895601d-6,  &
  +4.0_dp, +10.0_dp, -0.14341729937924d-12, &
  +5.0_dp,  -8.0_dp, -0.40516996860117d-6,  &
  +8.0_dp, -11.0_dp, -0.12734301741641d-8,  &
  +8.0_dp,  -6.0_dp, -0.17424871230634d-9,  &
 +21.0_dp, -29.0_dp, -0.68762131295531d-18, &
 +23.0_dp, -31.0_dp, +0.14478307828521d-19, &
 +29.0_dp, -38.0_dp, +0.26335781662795d-22, &
 +30.0_dp, -39.0_dp, -0.11947622640071d-22, &
 +31.0_dp, -40.0_dp, +0.18228094581404d-23, &
 +32.0_dp, -41.0_dp, -0.93537087292458d-25  &
], &
[3, 34])) !! Coefficients I, J and n for forward equation in region 1.
!--------------------------------------------------------------------------------------------------------------------------------



! Region 4: Saturation line
!--------------------------------------------------------------------------------------------------------------------------------
real(dp) :: r4_n(10) = [  &
+0.11670521452767e4_dp,   &
-0.72421316703206e6_dp,   &
-0.1707384694009292e2_dp, &
+0.12020824702470e5_dp,   &
-0.32325550322333e7_dp,   &
+0.14915108613530e2_dp,   &
-0.48232657361591e4_dp,   &
+0.40511340542057e6_dp,   &
-0.23855557567849_dp,     &
+0.65017534844798e3_dp    &
] !! ni coefficients for region 4 (saturation line)

real(dp), parameter :: r4_Tmin = 273.15_dp     !! Lower bound for validity for ps(T) in K.
real(dp), parameter :: r4_Tmax = 647.096_dp    !! Upper bound for validity ps(T) in K.
real(dp), parameter :: r4_pmin = 611.213e-6_dp !! Lower bound for validity for Ts(p) in MPa.
real(dp), parameter :: r4_pmax = 22.064_dp     !! Upper bound for validity Ts(p) in MPa.

real(dp), parameter :: r4_Tstar = 1_dp         !! T* in K
real(dp), parameter :: r4_Pstar = 1_dp         !! p* MPa
!--------------------------------------------------------------------------------------------------------------------------------


contains


! Region 1
!--------------------------------------------------------------------------------------------------------------------------------
pure elemental function r1_g(p, T)result(res)
    !! Compute gamma for region 1.
    
    ! parameters
    real(dp), intent(in) :: p !! pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    !results
    real(dp) :: res
    
    !variables
    real(dp) :: pi
    real(dp) :: tau

    tau = r1_Ts/T
    pi = p/r1_ps
    
    res = sum(r1_IJn_g(:,3) * (7.1_dp-pi)**r1_IJn_g(:,1) * (tau-1.222_dp)**r1_IJn_g(:, 2))

end function

pure elemental function r1_gp(p, T)result(res)
    !! Compute gamma_pi for region 1.

    ! parameters
    real(dp), intent(in) :: p !! pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    ! results
    real(dp) :: res

    ! variables
    real(dp) :: pi
    real(dp) :: tau

    tau = r1_Ts/T
    pi = p/r1_ps

    res = sum(-r1_IJn_g(:,3)*r1_IJn_g(:,1)*(7.1-pi)**(r1_IJn_g(:,1)-1.0_dp) * (tau-1.222_dp)**(r1_IJn_g(:,2)))

end function

pure elemental function r1_v(p, T)result(res)
    !! Compute the specific volume v in m3/kg.

    ! parameters
    real(dp), intent(in) :: p !! pressure in Mpa.
    real(dp), intent(in) :: T !! Temperature in K.

    ! results
    real(dp) :: res
   
    ! variables
    real(dp) :: pi

    pi = p/r1_ps
    res = R*T/p * pi * r1_gp(p,T)
    
end function
!--------------------------------------------------------------------------------------------------------------------------------



! Region 4: Saturation line
!--------------------------------------------------------------------------------------------------------------------------------
pure elemental function r4_ps(Ts)result(value)
    !! Compute the saturation-pressure line. 
    !! Validity range 273.13 K <= Ts <= 647.096 K.

    real(dp), intent(in) :: Ts    !! Saturation temperature in K.
    real(dp) :: value             !! Saturation pressure in MPa at temperature Ts. Is nan if Ts is out of range.

    real(dp) :: theta, Ts_K, A, B, C
    

    if(Ts < r4_Tmin)then
        value = ieee_value(1.0_dp, ieee_quiet_nan)
    else if(Ts > r4_Tmax)then
        value = ieee_value(1.0_dp, ieee_quiet_nan)
    else
        Ts_K = Ts / r4_Tstar
        theta = Ts_K + r4_n(9) / (Ts_K - r4_n(10))

        A = theta**2           + r4_n(1) * theta + r4_n(2)
        B = r4_n(3) * theta**2 + r4_n(4) * theta + r4_n(5)
        C = r4_n(6) * theta**2 + r4_n(7) * theta + r4_n(8)
    
        value = r4_Pstar  *( 2*C /(-B +(B**2-4*A*C)**(0.5_dp)))**(4.0_dp)
    endif

end function

pure elemental function r4_Ts(ps)result(value)
    !! Compute the saturation-pressure line. 
    !! Validity range 611.213 Pa <= ps <= 22.064 MPa.

    real(dp), intent(in) :: ps  !! Saturation pressure in MPa.
    real(dp) :: value           !! Saturation temperature in K at pressure ps. Is nan if ps is out of range.

    real(dp) :: beta, D, E, F, G
    
    if(ps < r4_pmin)then
        value = ieee_value(1.0_dp, ieee_quiet_nan)
    else if(ps > r4_pmax)then
        value = ieee_value(1.0_dp, ieee_quiet_nan)
    else
        beta = (ps / r4_Pstar)**(0.25_dp)
        E = beta**2 + r4_n(3) * beta + r4_n(6)
        F = r4_n(1) * beta**2 + r4_n(4) * beta + r4_n(7)
        G = r4_n(2) * beta**2 + r4_n(5) * beta + r4_n(8)
        D = 2*G / (-F-(F**2-4*E*G)**(0.5_dp))
        value = r4_Tstar * (r4_n(10) + D - ((r4_n(10)+D)**2.0_dp - 4.0_dp*(r4_n(9)+r4_n(10)*D))**0.5_dp) / 2.0_dp
    endif
end function

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

!--------------------------------------------------------------------------------------------------------------------------------


end module
