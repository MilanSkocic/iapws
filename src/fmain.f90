program fmain
    use iso_fortran_env
    use iapws_G7_04
    implicit none
    real(real64) :: kh

    kh = iapws_G7_04_kh(300.0d0, &
                                    iapws_G7_04_Tc1_water, &
                                    iapws_G7_04_pc1_water, &
                                    iapws_G7_04_abc_water(1),&
                                    iapws_G7_04_aibi_water)

    print *, log(kH)
end program 