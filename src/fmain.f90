program fmain
    use iso_fortran_env
    use iapws_G7_04
    use iapws
    implicit none
    real(real64) :: kh
    integer(int32) :: status

    kh = iapws_G7_04_kh(300.0d0, &
                                    iapws_G7_04_Tc1_water, &
                                    iapws_G7_04_pc1_water, &
                                    iapws_G7_04_abc_water(1),&
                                    iapws_G7_04_aibi_water)

    print *, log(kH)

    call iapws_kh_water(300.0d0-273.15d0, "He", kh, status)
    print *, log(kh), status
    
    call iapws_kh_heavywater(300.0d0-273.15d0, "He", kh, status)
    print *, log(kh), status
    
    call iapws_kh_heavywater(300.0d0-273.15d0, "O2", kh, status)
    print *, log(kh), status
    
    call iapws_kh_heavywater(1000.0d0-273.15d0, "He", kh, status)
    print *, log(kh), status

    call iapws_kh(300.0d0-273.15d0, "He", "H2O", kh, status)
    print *, log(kh), status
    
    call iapws_kh(300.0d0-273.15d0, "O2", "D2O", kh, status)
    print *, log(kh), status
    
    call iapws_kh(1000.0d0-273.15d0, "He", "D2O", kh, status)
    print *, log(kh), status

end program 