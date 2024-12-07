module testsuite_r797
    use stdlib_kinds, only: dp, int32
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use iapws
    implicit none
    private
    
    public :: collect_suite_r797

contains

subroutine collect_suite_r797(testsuite)
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest("Psat", test_Psat), &
                 new_unittest("Tsat", test_Tsat), &
                 new_unittest("r1_v", test_r1_v)]
end subroutine

subroutine test_Psat(error)
    type(error_type), allocatable, intent(out) :: error 
    integer(int32) :: i
    real(dp) :: ps(3)
    real(dp) :: Ts(3) = [300.0_dp, 500.0_dp, 600.0_dp]
    real(dp) :: psref(3) = [0.353658941d-2, 0.263889776d1, 0.123443146d2]
    real(dp) :: c(3) = [1d2, 1d-1, 1d-2]
    
    call psat(Ts, ps)
    
    ! check ref values from Table 35.
    do i=1, size(Ts)
        call check(error, ps(i)*c(i), psref(i)*c(i), thr=1d-9)
        if (allocated(error)) return
    end do

end subroutine

subroutine test_Tsat(error)
    type(error_type), allocatable, intent(out) :: error 
    integer(int32) :: i
    real(dp) :: Ts(3)
    real(dp) :: ps(3) = [0.1_dp, 1.0_dp, 10.0_dp]
    real(dp) :: Tsref(3) = [0.372755919d3, 0.453035632d3, 0.584149488d3]
    real(dp) :: c(3) = [1d-3, 1d-3, 1d-3]
    
    call Tsat(ps, Ts)
    
    ! check ref values from Table 36.
    do i=1, size(Ts)
        call check(error, Ts(i)*c(i), Tsref(i)*c(i), thr=1d-9)
        if (allocated(error)) return
    end do

end subroutine


subroutine test_r1_v(error)
    type(error_type), allocatable, intent(out) :: error 
    integer(int32) :: i
    real(dp) :: T(3) = [300.0_dp, 300.0_dp, 500.0_dp]
    real(dp) :: p(3) = [3.0_dp, 80.0_dp, 3.0_dp]
    real(dp) :: vref(3) = [0.100215168d-2, 0.971180894d-3, 0.120241800d-2]
    real(dp) :: c(3) = [1d2, 1d3, 1d2]
    
    do i=1, size(T)
        call check(error, r1_v(p(i), T(i))*c(i), vref(i)*c(i), thr=1d-9)
        if (allocated(error)) return
    end do

end subroutine

end module
