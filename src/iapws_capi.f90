!> @file

!> @brief C API for the IAPWS module.
module iapws_capi
    use iso_fortran_env
    use iso_c_binding
    use iapws
    implicit none
    private

    public :: iapws_capi_kh, iapws_capi_Scm3, iapws_capi_Sppm

contains

!> @brief Compute the henry constant for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @param[in] size_gas Length of the string gas.
!! @param[in] size_solvent Length of the string gas.
!! @return kh Henry constante in mole fraction per GPa. NaN if gas not found.
function iapws_capi_kh(T, gas, solvent, size_gas, size_solvent)bind(C)result(kh)
    !! arguments
    real(c_double), value :: T
    type(c_ptr), intent(in), value :: gas
    type(c_ptr), intent(in), value :: solvent 
    integer(c_int), intent(in), value :: size_gas
    integer(c_int), intent(in), value :: size_solvent
    !! returns
    real(c_double) :: kh
    
    !! local variables
    character, pointer, dimension(:) :: c2f_gas
    character, pointer, dimension(:) :: c2f_solvent
    character(len=size_gas) :: f_gas
    character(len=size_solvent) :: f_solvent
    integer(int32) :: i

    call c_f_pointer(gas, c2f_gas, shape=[size_gas])
    call c_f_pointer(solvent, c2f_solvent, shape=[size_solvent])

    do i=1, size_gas
        f_gas(i:i) = c2f_gas(i)
    enddo
    
    do i=1, size_solvent
        f_solvent(i:i) = c2f_solvent(i)
    enddo

    kh = iapws_kH(T, f_gas, f_solvent)

end function

!> @brief Compute the solubility constant for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @param[in] size_gas Length of the string gas.
!! @param[in] size_solvent Length of the string gas.
!! @return Scm3 Solubility constant in cm3.kg-1.bar-1. NaN if gas not found.
function iapws_capi_scm3(T, gas, solvent, size_gas, size_solvent)bind(C)result(Scm3)
    !! arguments
    real(c_double), value :: T
    type(c_ptr), intent(in), value :: gas
    type(c_ptr), intent(in), value :: solvent 
    integer(c_int), intent(in), value :: size_gas
    integer(c_int), intent(in), value :: size_solvent
    !! returns
    real(c_double) :: Scm3
    
    !! local variables
    character, pointer, dimension(:) :: c2f_gas
    character, pointer, dimension(:) :: c2f_solvent
    character(len=size_gas) :: f_gas
    character(len=size_solvent) :: f_solvent
    integer(int32) :: i

    call c_f_pointer(gas, c2f_gas, shape=[size_gas])
    call c_f_pointer(solvent, c2f_solvent, shape=[size_solvent])

    do i=1, size_gas
        f_gas(i:i) = c2f_gas(i)
    enddo
    
    do i=1, size_solvent
        f_solvent(i:i) = c2f_solvent(i)
    enddo

    Scm3 = iapws_Scm3(T, f_gas, f_solvent)

end function

!> @brief Compute the solubility constant for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @param[in] size_gas Length of the string gas.
!! @param[in] size_solvent Length of the string gas.
!! @return Sppm Solubility constant in ppm. NaN if gas not found.
function iapws_capi_sppm(T, gas, solvent, size_gas, size_solvent)bind(C)result(Sppm)
    !! arguments
    real(c_double), value :: T
    type(c_ptr), intent(in), value :: gas
    type(c_ptr), intent(in), value :: solvent 
    integer(c_int), intent(in), value :: size_gas
    integer(c_int), intent(in), value :: size_solvent
    !! returns
    real(c_double) :: Sppm
    
    !! local variables
    character, pointer, dimension(:) :: c2f_gas
    character, pointer, dimension(:) :: c2f_solvent
    character(len=size_gas) :: f_gas
    character(len=size_solvent) :: f_solvent
    integer(int32) :: i

    call c_f_pointer(gas, c2f_gas, shape=[size_gas])
    call c_f_pointer(solvent, c2f_solvent, shape=[size_solvent])

    do i=1, size_gas
        f_gas(i:i) = c2f_gas(i)
    enddo
    
    do i=1, size_solvent
        f_solvent(i:i) = c2f_solvent(i)
    enddo

    Sppm = iapws_Sppm(T, f_gas, f_solvent)

end function
end module