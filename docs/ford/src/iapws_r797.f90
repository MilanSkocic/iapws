module iapws__r797
    !! Module for IAPWS R7-97: Not fully implemented - under development.
    use iapws__common
    use iapws__r283, only: Tc_H2O, pc_H2O, rhoc_H2O
    implicit none
    private

    public :: find_region, find_phase, is1region, get_r, rai
    public :: r1_v, r1_u, r1_s, r1_h, r1_cp, r1_cv, r1_w, r1
    public :: r4_ps, r4_Ts
    
    real(dp), parameter :: T_KELVIN = 273.15_dp !! Parameters from IAPWS R7-97
    real(dp), parameter :: Tc = Tc_H2O          !! critical temperature of water in K
    real(dp), parameter :: pc = pc_H2O          !! critical pressure of the water in MPa
    real(dp), parameter :: rhoc = rhoc_H2O      !! critical density of the water in kg.m-3.

    real(dp), parameter :: R = 0.461526_dp      !! Specific gas constant 0.461 526 kJ.kg-1.K-1


! Region 1
!-------------------------------------------------------------------------------
real(dp), parameter :: r1_ps = 16.53_dp !! p* in MPa.
real(dp), parameter :: r1_Ts = 1386.0_dp !! T* in K.

real(dp), parameter :: r1_Tmin = 273.15_dp  !! T in K.
real(dp), parameter :: r1_Tmax = 623.15_dp  !! T in K.
real(dp), parameter :: r1_pmax = 100.0_dp   !! p in MPa.

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
!-------------------------------------------------------------------------------



! Region 2
!-------------------------------------------------------------------------------
real(dp), parameter :: r2_T1min = 273.15_dp     !! T in K.
real(dp), parameter :: r2_T1max = 623.15_dp     !! T in K.
real(dp), parameter :: r2_T2min = r2_T1max      !! T in K.
real(dp), parameter :: r2_T2max = 863.15_dp     !! T in K.
real(dp), parameter :: r2_T3min = r2_T2max      !! T in K.
real(dp), parameter :: r2_T3max = 1073.15_dp     !! T in K.
real(dp), parameter :: r2_pmin = 0.000_dp       !! T in K.
real(dp), parameter :: r2_pmax = 100.0_dp        !! T in K.
!-------------------------------------------------------------------------------



! Region 3
!-------------------------------------------------------------------------------
real(dp), parameter :: r3_Tmin = 623.15_dp      !! T in K.
real(dp), parameter :: r3_pmax = 100.0_dp        !! T in K.
!-------------------------------------------------------------------------------



! Region 4: Saturation line
!-------------------------------------------------------------------------------
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
!-------------------------------------------------------------------------------




! Region 5
!-------------------------------------------------------------------------------
real(dp), parameter :: r5_Tmin = 1073.15_dp     !! T in K.
real(dp), parameter :: r5_Tmax = 2273.15_dp     !! T in K.
real(dp), parameter :: r5_pmin = 0.000_dp       !! T in K.
real(dp), parameter :: r5_pmax = 50.0_dp        !! T in K.
!-------------------------------------------------------------------------------

abstract interface
    pure subroutine rai(p, T, prop, res)
        use iapws__common
        real(dp), intent(in) :: p(:)
        real(dp), intent(in) :: T(:)
        character(len=*), intent(in) :: prop
        real(dp), intent(out) :: res(:)
    end subroutine
end interface


contains


pure elemental function find_region(p, T)result(res)
    !! Find the corresponding region according to p and T.
    !! Return the number of the region (1 to 5) when found otherwise return -1.
    
    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    ! results
    integer(int32) :: res

    ! variables
    real(dp) :: ps, p23, T23

    res = -1
    ps=r4_ps(T)

    ! test region 1
    if((T>=r1_Tmin) .and. (T<=r1_Tmax))then
        if((p>=ps) .and. (p<=r1_pmax))then
            res = 1
        end if
    end if

    ! test region 2
    if((T>=r2_T1min) .and. (T<=r2_T1max))then
        if((p>r2_pmin) .and. (p<=ps))then
            res = 2
        end if
    end if

    if((T>=r2_T2min) .and. (T<=r2_T2max))then
        ! p23 = b23_p(T)
        p23 = 100.0_dp ! to change after implementing the boundary equation between region 2 and 3.
        if((p>r2_pmin) .and. (p<=p23))then
            res = 2
        end if
    end if
    
    if((T>=r2_T3min) .and. (T<=r2_T3max))then
        if((p>r2_pmin) .and. (p<=r2_pmax))then
            res = 2
        end if
    end if
    
    ! test Region 3
    ! T23 = b23_T(p)
    ! p23 = b23_p(T)
    T23 = 1073.15_dp ! change after implementing b23 equation
    p23 = 10.0_dp    ! change after implementing b23 equation
    if((T>=r3_Tmin) .and. (T<=T23))then
        if((p>=p23) .and. (p<=r3_pmax))then
            res = 3
        end if
    end if

    ! test region 5
    if((T>=r5_Tmin) .and. (T<=r5_Tmax))then
        if((p>=r5_pmin) .and. (p<=r5_pmax))then
            res = 5
        end if
    end if
end function

pure elemental function find_phase(p, T)result(res)
    !! Find the corresponding phase according to p and T.
    !! Return the phase as an character: l=LIQUID, v=VAPOR, c=SUPER CRITICAL, s=SATURATION, n=UNKNOWN.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    ! results
    character(len=1) :: res

    ! local variables 
    integer(int32) :: region

    region = find_region(p, T)

    select case(region)
        case (1)
            res = "l"
        case (2)
            res = "v"
        case (3)
            res = "c"
        case (4)
            res = "s"
        case (5)
            res = "v"
        case default
            res = "n"
    end select
end function

pure function is1region(regions)result(res)
    !! Check if all regions are identical

    ! parameters
    integer(int32), intent(in) :: regions(:)

    ! returns
    logical :: res

    ! variables
    integer(int32) :: i

    res = .true.
    do i=2, size(regions)
        if(regions(i) /= regions(i))then
            res = .false.
            exit
        endif
    end do
end function

pure elemental function get_r(region)result(fptr)
    !! Get the pointer to the adequate region subroutine
    
    ! parameters
    integer(int32), intent(in) :: region
    
    ! returns
    procedure(rai), pointer :: fptr


    nullify(fptr)
    select case (region)
        case (1)
            fptr => r1
        case default
            fptr => null()
    end select
end function


! Region 1
!-------------------------------------------------------------------------------
pure elemental function r1_g(p, T)result(res)
    !! Compute gamma for region 1.
    
    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    !results
    real(dp) :: res
    
    !variables
    real(dp) :: pi
    real(dp) :: tau

    tau = r1_Ts/T
    pi = p/r1_ps
    
    res = sum(r1_IJn_g(:,3) * (7.1_dp-pi)**r1_IJn_g(:,1) * &
                             (tau-1.222_dp)**r1_IJn_g(:, 2))
end function

pure elemental function r1_gp(p, T)result(res)
    !! Compute gamma_pi for region 1.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    ! results
    real(dp) :: res

    ! variables
    real(dp) :: pi
    real(dp) :: tau

    tau = r1_Ts/T
    pi = p/r1_ps

    res = sum(-r1_IJn_g(:,3) * r1_IJn_g(:,1)*(7.1_dp-pi)**(r1_IJn_g(:,1)-1.0_dp) * &
                                             (tau-1.222_dp)**r1_IJn_g(:,2))
end function

pure elemental function r1_gt(p, T)result(res)
    !! Compute gamma_tau for region 1.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    ! results
    real(dp) :: res

    ! variables
    real(dp) :: pi
    real(dp) :: tau

    tau = r1_Ts/T
    pi = p/r1_ps

    res = sum(r1_IJn_g(:,3) * (7.1_dp-pi)**r1_IJn_g(:,1) * & 
              r1_IJn_g(:,2) * (tau-1.222_dp)**(r1_IJn_g(:,2)-1.0_dp))
end function

pure elemental function r1_gpp(p, T)result(res)
    !! Compute gamma_pipi for region 1.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    ! results
    real(dp) :: res

    ! variables
    real(dp) :: pi
    real(dp) :: tau

    tau = r1_Ts/T
    pi = p/r1_ps

    res = sum(r1_IJn_g(:,3) * r1_IJn_g(:,1) * (r1_IJn_g(:,1)-1.0_dp) * (7.1_dp-pi)**(r1_IJn_g(:,1)-2.0_dp) * &
                                                                       (tau-1.222_dp)**r1_IJn_g(:,2))
end function

pure elemental function r1_gtt(p, T)result(res)
    !! Compute gamma_tautau for region 1.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    ! results
    real(dp) :: res

    ! variables
    real(dp) :: pi
    real(dp) :: tau

    tau = r1_Ts/T
    pi = p/r1_ps

    res = sum(r1_IJn_g(:,3) * (7.1_dp-pi)**r1_IJn_g(:,1) * & 
              r1_IJn_g(:,2) * (r1_IJn_g(:,2)-1.0_dp) * (tau-1.222_dp)**(r1_IJn_g(:,2)-2.0_dp))
end function

pure elemental function r1_gpt(p, T)result(res)
    !! Compute gamma_pitau for region 1.
    
    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.
    
    !results
    real(dp) :: res
    
    !variables
    real(dp) :: pi
    real(dp) :: tau

    tau = r1_Ts/T
    pi = p/r1_ps
    
    res = sum(-r1_IJn_g(:,3) * r1_IJn_g(:,1) * (7.1_dp-pi)**(r1_IJn_g(:,1)-1.0_dp) * &
                               r1_IJn_g(:,2) * (tau-1.222_dp)**(r1_IJn_g(:, 2)-1.0_dp))
end function

pure elemental function r1_v(p, T)result(res)
    !! Compute the specific volume v in m3/kg.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.

    ! results
    real(dp) :: res
   
    ! variables
    real(dp) :: pi

    pi = p/r1_ps
    res = R*T/p * pi * r1_gp(p,T) * 1d-3 ! RT/p is in L/kg.
end function

pure elemental function r1_u(p, T)result(res)
    !! Compute the specific internal energy u in m3/kg.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.

    ! results
    real(dp) :: res
   
    ! variables
    real(dp) :: pi, tau

    pi = p/r1_ps
    tau = r1_Ts/T
    res = R*T * (tau * r1_gt(p,T) - pi * r1_gp(p,T))
end function

pure elemental function r1_s(p, T)result(res)
    !! Compute the specific enthropy h in kJ/kg/K.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.

    ! results
    real(dp) :: res
   
    ! variables
    real(dp) :: tau

    tau = r1_Ts/T
    res = R * (tau * r1_gt(p,T) - r1_g(p,T))
end function

pure elemental function r1_h(p, T)result(res)
    !! Compute the specific enthalpie h in kJ/kg.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.

    ! results
    real(dp) :: res
   
    ! variables
    real(dp) :: tau

    tau = r1_Ts/T
    res = R*T * tau * r1_gt(p,T)
end function

pure elemental function r1_cp(p, T)result(res)
    !! Compute the specific isobaric heat capacity cp in kJ/kg/K.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.

    ! results
    real(dp) :: res
   
    ! variables
    real(dp) :: tau

    tau = r1_Ts/T
    res = -R * tau**2.0_dp * r1_gtt(p,T)
end function

pure elemental function r1_cv(p, T)result(res)
    !! Compute the specific isochoric heat capacity cp in kJ/kg/K.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.

    ! results
    real(dp) :: res
   
    ! variables
    real(dp) :: tau

    tau = r1_Ts/T
    res = R * ( -tau**2.0_dp * r1_gtt(p,T) + (r1_gp(p,T)-tau*r1_gpt(p,T))**2.0_dp/r1_gpp(p,T) )
end function

pure elemental function r1_w(p, T)result(res)
    !! Compute the speed of sound w in m/s.

    ! parameters
    real(dp), intent(in) :: p !! Pressure in MPa.
    real(dp), intent(in) :: T !! Temperature in K.

    ! results
    real(dp) :: res
   
    ! variables
    real(dp) :: tau

    tau = r1_Ts/T
    ! RT is kJ.kg-1 = 10^3 J.kg-1
    ! 1J = 1kg.m2.s-2
    ! RT in 10^3 m2.s-2.
    res = 1d3*R*T * ( r1_gp(p,T)**2.0_dp / & 
                ( (r1_gp(p,T)-tau*r1_gpt(p,T))**2.0_dp / (tau**2.0_dp*r1_gtt(p,T)) - r1_gpp(p,T) ) &
                )
    res = sqrt(res) ! in m.s-1
end function

pure subroutine r1(p, T, prop, res)
    !! Compute water properties at pressure p in MPa and temperature T in Kelvin.
    !! in region 1.
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
    real(dp), intent(out) :: res(:)              !! Result 

    select case (prop)
        case ("v")
            res = r1_v(p, T)
        case ("u")
            res = r1_u(p, T)
        case ("s")
            res = r1_s(p, T)
        case ("h")
            res = r1_h(p, T)
        case ("cp")
            res = r1_cp(p, T)
        case ("cv")
            res = r1_cv(p, T)
        case ("w")
            res = r1_w(p, T)
        case default
            res = ieee_value(1.0_dp, ieee_quiet_nan)
    end select
end subroutine
!-------------------------------------------------------------------------------


! Boundary between region 2 and 3
!-------------------------------------------------------------------------------

!-------------------------------------------------------------------------------



! Region 2
!-------------------------------------------------------------------------------

!-------------------------------------------------------------------------------



! Region 3
!-------------------------------------------------------------------------------

!-------------------------------------------------------------------------------



! Region 4: Saturation line
!-------------------------------------------------------------------------------
pure elemental function r4_ps(Ts)result(value)
    !! Compute the saturation-pressure line. 
    !! Validity range 273.13 K <= Ts <= 647.096 K.

    real(dp), intent(in) :: Ts    !! Saturation temperature in K.
    real(dp) :: value             !! Saturation Pressure in MPa at temperature Ts. Is nan if Ts is out of range.

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

    real(dp), intent(in) :: ps  !! Saturation Pressure in MPa.
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
!-------------------------------------------------------------------------------



! Region 5
!-------------------------------------------------------------------------------

!-------------------------------------------------------------------------------

end module
