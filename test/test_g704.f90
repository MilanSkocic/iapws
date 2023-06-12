program test_g704
    use iso_fortran_env
    use iapws_g704
    implicit none

    integer(int32) :: i
    integer(real64) :: value
    integer(real64) :: expected
    integer(real64) :: diff
    integer(int32) :: heavywater

    type(iapws_g704_gas_t), pointer :: gases_list_H2O(:)
    type(iapws_g704_gas_t), pointer :: gases_list_D2O(:)
    character(len=5) :: expected_gases_H2O(14) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
    character(len=5) :: expected_gases_D2O(7) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
    integer(int32) :: diff_gas_H2O(14)
    integer(int32) :: diff_gas_D2O(7)
    
    character(len=*), parameter :: expected_gases_str_H2O = "He,Ne,Ar,Kr,Xe,H2,N2,O2,CO,CO2,H2S,CH4,C2H6,SF6"
    character(len=*), parameter :: expected_gases_str_D2O = "He,Ne,Ar,Kr,Xe,D2,CH4"
    character(len=:), pointer :: gases_str


    print "(A)", "***** TESTING FORTRAN CODE FOR G704 *****"

    ! TEST ngases
    write(*, "(4X, A)", advance="no") "ngases in water..."
    heavywater = 0;
    expected = 14;
    value = iapws_g704_ngases(heavywater);
    diff = value - expected;
    if(diff /= 0)then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, I0.2, A1, I0.2, A1, I0.2)", advance="yes") value, "/", expected, "/", diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif
    
    write(*, "(4X, A)", advance="no") "ngases in heavywater..."
    heavywater = 1;
    expected = 7;
    value = iapws_g704_ngases(heavywater);
    diff = value - expected;
    if(diff /= 0)then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, I0.2, A1, I0.2, A1, I0.2)", advance="yes") value, "/", expected, "/", diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif
    
    ! TEST gases
    write(*, "(4X, A)", advance="no") "gases in water..."
    heavywater = 0
    gases_list_H2O => iapws_g704_gases(heavywater)
    do i=1, 14
        diff_gas_H2O(i) = gases_list_H2O(i)%gas == expected_gases_H2O(i)
    enddo
    if(sum(diff_gas_H2O)== size(diff_gas_H2O))then
        write(*, "(A)", advance="yes") "OK"
    else
        write(*, "(A)", advance="yes") "Failed"
        do i=1, 14
            write(*, "(4X, A, 4X, A, 4X, L)", advance="yes") &
            gases_list_H2O(i)%gas, expected_gases_H2O(i), diff_gas_H2O(i)
        enddo
        stop 1
    endif
    
    write(*, "(4X, A)", advance="no") "gases in water..."
    heavywater = 1
    gases_list_D2O => iapws_g704_gases(heavywater)
    do i=1, 7
        diff_gas_D2O(i) = gases_list_D2O(i)%gas == expected_gases_D2O(i)
    enddo
    if(sum(diff_gas_D2O)== size(diff_gas_D2O))then
        write(*, "(A)", advance="yes") "OK"
    else
        write(*, "(A)", advance="yes") "Failed"
        do i=1, 7
            write(*, "(4X, A, 4X, A, 4X, L)", advance="yes") &
            gases_list_D2O(i)%gas, expected_gases_D2O(i), diff_gas_D2O(i)
        enddo
        stop 1
    endif


    ! TEST gases2
    write(*, "(4X, A)", advance="no") "gases2 in water..."
    heavywater = 0
    gases_str => iapws_g704_gases2(heavywater)
    if(expected_gases_str_H2O == gases_str)then
        write(*, "(A)", advance="yes") "OK"
    else
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, A)", advance="yes") gases_str
        write(*, "(4X, A)", advance="yes") expected_gases_str_H2O
        stop 1
    endif

    write(*, "(4X, A)", advance="no") "gases2 in heavywater..."
    heavywater = 1
    gases_str => iapws_g704_gases2(heavywater)
    if(expected_gases_str_D2O == gases_str)then
        write(*, "(A)", advance="yes") "OK"
    else
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, A)", advance="yes") gases_str
        write(*, "(4X, A)", advance="yes") expected_gases_str_D2O
    endif

contains


end program