program test_iapws_g704_ngases
    use iso_fortran_env
    use iapws_g704
    implicit none

    integer(int32) :: value
    integer(int32) :: expected
    integer(int32) :: diff
    integer(int32) :: heavywater

    print "(A)", "***** F Test ngases in water *****"
    heavywater = 0;
    expected = 14;
    value = iapws_g704_ngases(heavywater);
    diff = value - expected;
    print "(I0.2, A1, I0.2, A1, I0.2)", value, "/", expected, "/", diff
    if(diff /= 0)then
        stop 1
    endif
    
    print "(A)", "***** F Test ngases in heavywater *****"
    heavywater = 1;
    expected = 7;
    value = iapws_g704_ngases(heavywater);
    diff = value - expected;
    print "(I0.1, A1, I0.1, A1, I0.1)", value, "/", expected, "/", diff
    if(diff /= 0)then
        stop 1
    endif

end program