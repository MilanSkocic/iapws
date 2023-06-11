program test_iapws_g704_gases
    use iso_fortran_env
    use iapws
    implicit none

    integer(int32) :: heavywater
    character(len=:), pointer :: gases

    print "(A)", "***** F Test gases str in water *****"
    heavywater = 0
    gases => iapws_g704_gases2(heavywater)
    print "(A, I3)", gases
    
    print "(A)", "***** F Test gases str in heavywater *****"
    heavywater = 1
    gases => iapws_g704_gases2(heavywater)
    print "(A, I3)", gases

end program