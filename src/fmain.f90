program fmain
    use iapws_G7_04
    implicit none
    real(real64) :: kH
    kh = iapws_G7_04_henry_constant(1, 400.0d0, Tc1_water, pc1_water, ni_water, ai_water, bi_water, abc_water)

    print *, log(kH)
end program 