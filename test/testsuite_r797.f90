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
    testsuite = [new_unittest("Psat", test_Psat), new_unittest("Tsat", test_Tsat)]
end subroutine

subroutine test_Psat(error)
    type(error_type), allocatable, intent(out) :: error 
    integer(int32) :: i
    real(dp) :: ps(3)
    real(dp) :: Ts(3) = [300.0_dp, 500.0_dp, 600.0_dp]
    real(dp) :: psref(3) = [0.353658941e-2_dp, 0.263889776e1_dp, 0.123443146e2_dp]
    real(dp) :: th(3) = [1e-11_dp, 1e-8_dp, 1e-7_dp]
    
    call psat(Ts, ps)
    
    ! check ref values from Table 35.
    do i=1, size(Ts)
        call check(error, ps(i), psref(i), thr=th(i))
        if (allocated(error)) return
    end do

end subroutine

subroutine test_Tsat(error)
    type(error_type), allocatable, intent(out) :: error 
    integer(int32) :: i
    real(dp) :: Ts(3)
    real(dp) :: ps(3) = [0.1_dp, 1.0_dp, 10.0_dp]
    real(dp) :: Tsref(3) = [0.372755919e3_dp, 0.453035632e3_dp, 0.584149488e3_dp]
    real(dp) :: th(3) = [1e-6_dp, 1e-6_dp, 1e-6_dp]
    
    call Tsat(ps, Ts)
    
    ! check ref values from Table 36.
    do i=1, size(Ts)
        call check(error, Ts(i), Tsref(i), thr=th(i))
        if (allocated(error)) return
    end do

end subroutine

end module
