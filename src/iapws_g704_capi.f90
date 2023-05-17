!> @file
!! @brief C API for the IAPWS module.

!> @brief C API for the IAPWS module.
module iapws_capi
    use iso_fortran_env
    use iso_c_binding
    use iapws
    implicit none
    private

    public :: iapws_capi_kh, iapws_capi_kd

contains

!> @brief Compute the henry constant for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @param[in] size_gas Length of the string gas.
!! @param[in] size_solvent Length of the string gas.
!! @return kh Henry constant. NaN if gas not found.
function iapws_capi_kh(T, gas, solvent, size_gas, size_solvent)bind(C)result(kh)
    implicit none
    !! arguments
    real(c_double), value :: T
    type(c_ptr), intent(in), value :: gas
    type(c_ptr), intent(in), value :: solvent 
    integer(c_size_t), intent(in), value :: size_gas
    integer(c_size_t), intent(in), value :: size_solvent
    !! returns
    real(c_double) :: kh
    
    !! local variables
    character, pointer, dimension(:) :: c2f_gas
    character, pointer, dimension(:) :: c2f_solvent
    character(len=size_gas) :: f_gas
    character(len=size_solvent) :: f_solvent
    integer(int64) :: i

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

!> @brief Compute the vapor-liquid constant for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @param[in] size_gas Length of the string gas.
!! @param[in] size_solvent Length of the string gas.
!! @return kd Vapor-Liquid constant. NaN if gas not found.
function iapws_capi_kd(T, gas, solvent, size_gas, size_solvent)bind(C)result(kh)
    implicit none
    !! arguments
    real(c_double), value :: T
    type(c_ptr), intent(in), value :: gas
    type(c_ptr), intent(in), value :: solvent 
    integer(c_size_t), intent(in), value :: size_gas
    integer(c_size_t), intent(in), value :: size_solvent
    !! returns
    real(c_double) :: kh
    
    !! local variables
    character, pointer, dimension(:) :: c2f_gas
    character, pointer, dimension(:) :: c2f_solvent
    character(len=size_gas) :: f_gas
    character(len=size_solvent) :: f_solvent
    integer(int64) :: i

    call c_f_pointer(gas, c2f_gas, shape=[size_gas])
    call c_f_pointer(solvent, c2f_solvent, shape=[size_solvent])

    do i=1, size_gas
        f_gas(i:i) = c2f_gas(i)
    enddo
    
    do i=1, size_solvent
        f_solvent(i:i) = c2f_solvent(i)
    enddo

    kh = iapws_kd(T, f_gas, f_solvent)

end function
end module