program test_r283
    use iso_fortran_env
    use iapws__r283
    implicit none

    print "(A)", "***** TESTING FORTRAN CODE FOR R283 *****"
    call test_Tc_H2O()
    call test_Tc_D2O()

contains

pure elemental function roundn(x, n)result(r)
    implicit none
    real(real64), intent(in) :: x
    integer(int32), intent(in) :: n
    real(real64) :: r
    real(real64) :: fac

    fac = 10**n
    r = nint(x*fac, kind=kind(x)) / fac
end function

 function assertEqual(x1, x2, n)result(r)
    implicit none
    real(real64), intent(in) :: x1
    real(real64), intent(in) :: x2
    integer(int32), intent(in) :: n
    logical :: r

    real(real64) :: fac
    real(real64) :: ix1
    real(real64) :: ix2
    
    fac = 10**n
    ix1 = nint(x1 * fac, kind=kind(n))
    ix2 = nint(x2 * fac, kind=kind(n))
    r = ix1 == ix2


end function

subroutine test_Tc_H2O()
    implicit none 

    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "Tc in H2O..."

    expected = 647.096d0
    value = iapws_r283_Tc_H2O 
    diff = value - expected;
    if(diff /= 0)then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, ES23.16, A1, ES23.16, A1, ES23.16)", advance="yes") value, "/", expected, "/", diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif
end subroutine

subroutine test_Tc_D2O()
    implicit none 

    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "Tc in H2O..."

    expected = 643.847d0
    value = iapws_r283_Tc_D2O 
    diff = value - expected;
    if(diff /= 0)then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, ES23.16, A1, ES23.16, A1, ES23.16)", advance="yes") value, "/", expected, "/", diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif
end subroutine

end program