module testsuite_g704
    use iso_fortran_env
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use iapws
    implicit none
    private
    
    public :: collect_suite_g704

contains

subroutine collect_suite_g704(testsuite)
    implicit none
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest("ngases in H2O", test_ngases_H2O),&
                 new_unittest("ngases in D2O", test_ngases_D2O),&
                 new_unittest("gases in H2O", test_gases_H2O),&
                 new_unittest("gases in D2O", test_gases_D2O),&
                 new_unittest("gases2 in H2O", test_gases2_H2O),&
                 new_unittest("gases2 in D2O", test_gases2_D2O)]
end subroutine

subroutine test_ngases_H2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    integer(int32) :: value, expected
    
    expected = 14
    value = iapws_g704_ngases(0)

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_ngases_D2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    integer(int32) :: value, expected
    
    expected = 7
    value = iapws_g704_ngases(1)

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_gases_H2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    character(len=5) :: value, expected
    type(iapws_g704_gas_t), pointer :: gases_list(:)
    integer(int32), parameter :: n = 14
    integer(int32) :: i
    
    character(len=5) :: expected_gases(n) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
    
    gases_list => iapws_g704_gases(0)
    
    do i=1, n
        value = gases_list(i)%gas
        expected = expected_gases(i)
        call check(error, value, expected)
        if (allocated(error)) return
    enddo
end subroutine

subroutine test_gases_D2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    character(len=5) :: value, expected
    type(iapws_g704_gas_t), pointer :: gases_list(:)
    integer(int32), parameter :: n = 7
    integer(int32) :: i
    
    character(len=5) :: expected_gases(n) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
    
    gases_list => iapws_g704_gases(1)
    
    do i=1, n
        value = gases_list(i)%gas
        expected = expected_gases(i)
        call check(error, value, expected)
        if (allocated(error)) return
    enddo
end subroutine


subroutine test_gases2_H2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    character(len=*), parameter :: expected = "He,Ne,Ar,Kr,Xe,H2,N2,O2,CO,CO2,H2S,CH4,C2H6,SF6"
    character(len=:), pointer :: value 

    value => iapws_g704_gases2(0)
    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_gases2_D2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    character(len=*), parameter :: expected = "He,Ne,Ar,Kr,Xe,D2,CH4"
    character(len=:), pointer :: value

    value => iapws_g704_gases2(1)
    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

end module
