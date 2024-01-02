program test_r283
    use iso_fortran_env
    use test__common
    use iapws__r283
    implicit none

    print "(A)", "***** TESTING FORTRAN CODE FOR R283 *****"
    call test_Tc_H2O()
    call test_Tc_D2O()
    call test_pc_H2O()
    call test_pc_D2O()
    call test_rhoc_H2O()
    call test_rhoc_D2O()

contains

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
    
    write(*, "(4X, A)", advance="no") "Tc in D2O..."

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

subroutine test_pc_H2O()
    implicit none 

    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "pc in H2O..."

    expected = 22.064d0
    value = iapws_r283_pc_H2O 
    diff = value - expected;
    if(diff /= 0)then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, ES23.16, A1, ES23.16, A1, ES23.16)", advance="yes") value, "/", expected, "/", diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif
end subroutine

subroutine test_pc_D2O()
    implicit none 

    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "pc in D2O..."

    expected = 21.671d0
    value = iapws_r283_pc_D2O 
    diff = value - expected;
    if(diff /= 0)then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, ES23.16, A1, ES23.16, A1, ES23.16)", advance="yes") value, "/", expected, "/", diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif
end subroutine

subroutine test_rhoc_H2O()
    implicit none 

    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "rhoc in H2O..."

    expected = 322.0d0
    value = iapws_r283_rhoc_H2O
    diff = value - expected;
    if(diff /= 0)then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, ES23.16, A1, ES23.16, A1, ES23.16)", advance="yes") value, "/", expected, "/", diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif
end subroutine

subroutine test_rhoc_D2O()
    implicit none 

    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "rhoc in D2O..."

    expected = 356.0d0
    value = iapws_r283_rhoc_D2O
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