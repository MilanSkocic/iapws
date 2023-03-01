!> @file

!> @brief C API for the IAPWS module.
module iapws_capi
    use iso_fortran_env
    use iso_c_binding
    use iapws
    implicit none
    private

    public :: iapws_capi_kh

contains

!> @brief Compute the henry constante for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @param[out] kh Henry constante in mole fraction per GPa. NaN if status > 0.
!! @param[out] status 0: no error, 1: gas not found, 2: T out of bounds.
!! @param[in] size_gas Length of the string gas.
!! @param[in] size_solvent Length of the string gas.
subroutine iapws_capi_kh(T, gas, solvent, kh, status, size_gas, size_solvent)bind(C)
    !! arguments
    real(c_double), value :: T
    type(c_ptr), intent(in), value :: gas
    type(c_ptr), intent(in), value :: solvent 
    real(real64), intent(out) :: kh
    integer(int32), intent(out) :: status 
    integer(c_int), intent(in), value :: size_gas
    integer(c_int), intent(in), value :: size_solvent
    
    !! local variables
    character, pointer, dimension(:) :: c2f_gas
    character, pointer, dimension(:) :: c2f_solvent
    character(len=size_gas) :: f_gas
    character(len=size_solvent) :: f_solvent
    integer(int32) :: i

    call c_f_pointer(gas, c2f_gas, shape=[size_gas])
    call c_f_pointer(gas, c2f_solvent, shape=[size_solvent])

    do i=1, size_gas
        f_gas(i:i) = c2f_gas(i)
    enddo
    
    do i=1, size_solvent
        f_solvent(i:i) = c2f_solvent(i)
    enddo

    call iapws_kH(T, f_gas, f_solvent, kh, status)

end subroutine

end module