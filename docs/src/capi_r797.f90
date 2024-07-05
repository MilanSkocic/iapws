module iapws__capi_r797
    use stdlib_kinds, only: dp, int32
    use iso_c_binding, only: c_double, c_int, c_size_t
    use iapws__r797
    implicit none
    private
    
    public :: capi_psat, capi_Tsat

contains

pure subroutine capi_psat(N, Ts, ps)bind(C, name="iapws_r797_psat")
    !! Compute the saturation pressure at temperature Ts. 

    integer(c_size_t), intent(in), value :: N
    real(c_double), intent(in) :: Ts(N)
    real(c_double), intent(out) :: ps(N)

    call psat(Ts, ps)

end subroutine

pure subroutine capi_Tsat(N, ps, Ts)bind(C, name="iapws_r797_Tsat")
    !! Compute the saturation temperature at pressure ps.
    
    integer(c_size_t), intent(in), value :: N
    real(c_double), intent(in) ::   ps(N)
    real(c_double), intent(out) ::    Ts(N)
    
    call Tsat(ps, Ts)

end subroutine

end module iapws__capi_r797
