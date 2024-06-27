module iapws__r797
    !! Module for IAPWS R7-97: Not fully implemented - under development.
    use stdlib_kinds, only: dp
    use ieee_arithmetic
    use iapws__r283, only: Tc_H2O, pc_H2O, rhoc_H2O
    implicit none
    private

    public :: iapws_r797_v

    
real(dp), parameter :: T_KELVIN = 273.15_dp !! Parameters from IAPWS R7-97
real(dp), parameter ::  Tc = Tc_H2O !! critical temperature of water in K
real(dp), parameter ::  pc = pc_H2O !! critical pressure of the water in MPa
real(dp), parameter :: rhoc = rhoc_H2O !! critical density of the water in kg.m-3.

real(dp), parameter :: R = 0.461526_dp !! Specific gas constant 0.461 526 kJ.kg-1.K-1



! Region 1
!--------------------------------------------------------------------------------------------------------------------------------
real(dp), parameter :: r1_ps = 16.53_dp ! p*
real(dp), parameter :: r1_ts = 1386.0_dp ! T*

real(dp) :: IJn_r1f(9, 3) = transpose(reshape([&
0.0_dp, -2.0_dp, 0.146_dp, &
0.0_dp, -1.0_dp, -0.84548187169114_dp, &
0.0_dp, 0.0_dp, -0.37563672040d1, &
0.0_dp, 1.0_dp, 0.33855169168385d1, &
0.0_dp, 2.0_dp, -0.95791963387872_dp,&
0.0_dp, 3.0_dp, 0.15772038513228_dp, &
0.0_dp, 4.0_dp, -0.16616417199501d-1, &
0.0_dp, 5.0_dp, -0.81214629983568d-3, &
1.0_dp, -9.0_dp, -0.28319080123804d-3], &
[3, 9])) !! Coefficients I, J and n for forward equation in region 1.
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

real(dp), parameter :: r4_Tmin = 273.15_dp !! Lower bound for validity for ps(T) in K.
real(dp), parameter :: r4_Tmax = 647.096_dp !! Upper bound for validity ps(T) in K.
real(dp), parameter :: r4_pmin = 611.213e-3_dp !! Lower bound for validity for Ts(p) in MPa
real(dp), parameter :: r4_pmax = 22.064_dp !! Upper bound for validity Ts(p) in MPa

real(dp), parameter :: r4_Tstar = 1_dp !! K
real(dp), parameter :: r4_Pstar = 1_dp !! MPa
!--------------------------------------------------------------------------------------------------------------------------------


public :: psat, Tsat 

contains


! Region 1
!--------------------------------------------------------------------------------------------------------------------------------
pure elemental function gamma_(P, T)result(res)
    implicit none

    real(dp), intent(in) :: P !! Pressure
    real(dp), intent(in) :: T !! Temperature
    
    real(dp) :: pi
    real(dp) :: tau
    real(dp) :: res

    pi = (T+T_KELVIN)/r1_ts
    tau = P/r1_ps
    
    res = sum(IJn_r1f(:,3) * (7.1_dp-pi)**IJn_r1f(:,1) * (tau-1.222_dp)**IJn_r1f(:, 2))

end function

pure elemental function gamma_pi(P, T)result(res)
    implicit none
    
    real(dp), intent(in) :: P
    real(dp), intent(in) :: T
    
    real(dp) :: pi
    real(dp) :: tau
    real(dp) :: res

    pi = (T+T_KELVIN)/r1_ts
    tau = P/r1_ps

    res = sum(IJn_r1f(:,3) * IJn_r1f(:,1) * (7.1_dp-pi)**(IJn_r1f(:,1)-1.0_dp) * (tau-1.222_dp)**IJn_r1f(:, 2))

end function

pure elemental function iapws_r797_v(P, T)result(res)
    implicit none
    
    real(dp), intent(in) :: P
    real(dp), intent(in) :: T

    real(dp) :: res
    
    res = R*(T+T_KELVIN)/P * gamma_pi(P,T)
    
end function
!--------------------------------------------------------------------------------------------------------------------------------



! Region 4: Saturation line
!--------------------------------------------------------------------------------------------------------------------------------
pure elemental function r4_ps(Ts)result(value)
    !! Compute the saturation-pressure line. Validity range 273.13 K (0°C) <= Ts <= 647.096 K (373.946°C).
    real(dp), intent(in) :: Ts    !! Saturation temperature in °C.
    real(dp) :: value !! Saturation pressure in MPa at temperature Ts. Is nan if Ts is out of range.

    real(dp) :: theta, T_K, Ts_K, A, B, C
    
    T_K = Ts + T_KELVIN

    if(T_K < r4_Tmin)then
        value = ieee_value(1.0_dp, ieee_quiet_nan)
    else if(T_K > r4_Tmax)then
        value = ieee_value(1.0_dp, ieee_quiet_nan)
    else
        Ts_K = T_K / r4_Tstar
        theta = Ts_K + r4_n(9) / (Ts_K - r4_n(10))

        A = theta**2           + r4_n(1) * theta + r4_n(2)
        B = r4_n(3) * theta**2 + r4_n(4) * theta + r4_n(5)
        C = r4_n(6) * theta**2 + r4_n(7) * theta + r4_n(8)
    
        value = r4_Pstar  *( 2*C /(-B +(B**2-4*A*C)**(0.5_dp)))**(4.0_dp)
    endif

end function

pure elemental function r4_Ts(ps)result(value)
    !! Compute the saturation-pressure line. Validity range 611.213 Pa (6.11213 bar) <= ps <= 22.064 MPa (220.64 bar).

    real(dp), intent(in) :: ps    !! Saturation pressure in MPa.
    real(dp) :: value !! Saturation temperature in °C at pressure ps. Is nan if ps is out of range.
    
    if(ps < r4_pmin)then
        value = ieee_value(1.0_dp, ieee_quiet_nan)
    else if(ps > r4_pmax)then
        value = ieee_value(1.0_dp, ieee_quiet_nan)
    else
        value = 1.0_dp     
    endif
end function

pure subroutine psat(Ts, ps)
    !! Compute the saturation pressure at temperature Ts. 
    real(dp), intent(in) :: Ts(:) !! Saturation temperature in °C
    real(dp), intent(out) :: ps(:)   !! Saturation pressure in MPa. Filled with nan if out of validity range.
    
    ps = r4_ps(Ts)

end subroutine

pure subroutine Tsat(ps, Ts)
    !! Compute the saturation pressure at temperature Ts.

    real(dp), intent(in) :: ps(:) !! Saturation temperature in °C
    real(dp), intent(out) :: Ts(:)   !! Saturation pressure in MPa.

    Ts = r4_Ts(ps)

end subroutine

!--------------------------------------------------------------------------------------------------------------------------------


end module
