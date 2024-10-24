module iapws__capi_r797
    use stdlib_kinds, only: dp, int32
    use iso_c_binding, only: c_double, c_int, c_size_t
    use iapws__r797
    implicit none
    private
    
    public :: capi_psat, capi_Tsat

contains

pure subroutine capi_psat(N, Ts, ps)bind(C, name="iapws_r797_psat")
    !! C API. 
    !! Compute the saturation pressure at temperature Ts. 
    !! Validity range 273.13 K <= Ts <= 647.096 K.

    integer(c_size_t), intent(in), value :: N     !! Size of Ts and ps.
    real(c_double), intent(in) :: Ts(N)           !! Saturation temperature in K.
    real(c_double), intent(out) :: ps(N)          !! Saturation pressure in MPa. Filled with nan if out of validity range.

    call psat(Ts, ps)

end subroutine

pure subroutine capi_Tsat(N, ps, Ts)bind(C, name="iapws_r797_Tsat")
    !! C API.
    !! Compute the saturation temperature at pressure ps.
    !! Validity range 611.213 Pa <= ps <= 22.064 MPa.
    
    integer(c_size_t), intent(in), value :: N     !! Size of ps and Ts.
    real(c_double), intent(in) ::   ps(N)         !! Saturation pressure in MPa.
    real(c_double), intent(out) ::  Ts(N)         !! Saturation temperature in K. Filled with nan if out of validity range.
    
    call Tsat(ps, Ts)

end subroutine

end module iapws__capi_r797
