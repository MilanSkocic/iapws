module testsuite_r283
    use iso_fortran_env
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use iapws
    implicit none
    private
    
    public :: collect_suite_r283

contains

subroutine collect_suite_r283(testsuite)
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest("Tc_H2O", test_TcH2O),&
                new_unittest("Tc_D2O", test_TcD2O),&         
                new_unittest("pc_H2O", test_pcH2O),&
                new_unittest("pc_D2O", test_pcD2O)]
end subroutine

subroutine test_TcH2O(error)
    type(error_type), allocatable, intent(out) :: error 

    real(real64) :: value, expected
    
    expected = 647.096d0
    value = Tc_H2O

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_TcD2O(error)
    type(error_type), allocatable, intent(out) :: error 

    real(real64) :: value, expected
    
    expected = 643.847d0
    value = Tc_D2O

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_pcH2O(error)
    type(error_type), allocatable, intent(out) :: error 

    real(real64) :: value, expected
    
    expected = 22.064d0
    value = pc_H2O

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_pcD2O(error)
    type(error_type), allocatable, intent(out) :: error 

    real(real64) :: value, expected
    
    expected = 21.671d0 
    value = pc_D2O

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

end module
