module testsuite_r1124
    use iapws__common
    use testdrive, only: new_unittest, unittest_type, error_type, check
    use iapws
    implicit none
    private

    public :: collect_suite_r1124

contains

subroutine collect_suite_r1124(testsuite)
    implicit none
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest("pKw", test_pKw)]
end subroutine


subroutine test_pKw(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    integer(int32), parameter :: n = 6
    integer(int32) :: i

    real(dp) :: value(n) 
    real(dp) :: T(n) =        [300.0_dp,     600.0_dp,     600.0_dp,     800.0_dp,     800.0_dp,     1270.0_dp]
    real(dp) :: rhow(n) =     [1.0_dp,       0.07_dp,      0.7_dp,       0.2_dp,       1.2_dp,       0.0_dp]
    real(dp) :: expected(n) = [13.906672_dp, 20.161651_dp, 11.147093_dp, 14.487671_dp, 6.4058649_dp, 35.081557_dp]
    
    call Kw(T, rhow, value)

    do i=1, n
        call check(error, -log10(value(i)), expected(i), thr=1d-6)
        if (allocated(error)) return
    enddo

end subroutine

end module
