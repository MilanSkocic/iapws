program tester
    use iso_fortran_env
    use testdrive, only : run_testsuite, new_testsuite, testsuite_type
    use testsuite_r283, only : collect_suite_r283
    use testsuite_g704, only : collect_suite_g704
    use testsuite_r797, only : collect_suite_r797
    use testsuite_r1124, only : collect_suite_r1124
    implicit none
    type(testsuite_type), allocatable :: testsuites(:)
    character(len=*), parameter :: fmt = '("#", *(1x, a))'
    integer :: stat, is

    stat = 0

    testsuites = [new_testsuite("R283", collect_suite_r283), &
                  new_testsuite("G704", collect_suite_g704), &
                  new_testsuite("R797", collect_suite_r797), &
                  new_testsuite("R1124", collect_suite_r1124)]
    do is = 1, size(testsuites)
        write(error_unit, fmt) "Testing:", testsuites(is)%name
        call run_testsuite(testsuites(is)%collect, error_unit, stat)
    end do

    if (stat > 0) then
        write(error_unit, '(i0, 1x, a)') stat, "test(s) failed!"
        error stop
    end if

end program
