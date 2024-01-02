module testsuite_g704
    use iso_fortran_env
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use iapws
    implicit none
    private
    
    public :: collect_suite_g704

contains

subroutine collect_suite_g704(testsuite)
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest("ngases in H2O", test_ngases_H2O),&
                 new_unittest("ngases in D2O", test_ngases_D2O)]
end subroutine

subroutine test_ngases_H2O(error)
    type(error_type), allocatable, intent(out) :: error 

    integer(int32) :: value, expected
    
    expected = 14
    value = iapws_g704_ngases(0)

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_ngases_D2O(error)
    type(error_type), allocatable, intent(out) :: error 

    integer(int32) :: value, expected
    
    expected = 7
    value = iapws_g704_ngases(1)

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

end module
