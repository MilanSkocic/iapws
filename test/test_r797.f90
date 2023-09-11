program test_r797
    use iso_fortran_env
    use iapws__r797
    implicit none

    print "(A)", "***** TESTING FORTRAN CODE FOR R797 *****"
    call test_regon1_v()

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

subroutine test_regon1_v()
    implicit none 

    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    real(real64) :: T
    real(real64) :: P
    
    write(*, "(4X, A)", advance="no") "region 1 v..."

    expected = 0.100215168d-2
    value = iapws_r797_v(P, T-273.15d0);
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