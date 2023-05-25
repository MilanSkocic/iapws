!> @file
!! @brief C API for the IAPWS module.

!> @brief C API for the IAPWS module.
module iapws_g704_capi
    use iso_fortran_env
    use iso_c_binding
    use iapws_g704
    implicit none
    private
    
    type, bind(C) :: c_char_p
        type(c_ptr) :: p
    end type
    type :: capi_gas_t
        character(kind=c_char, len=1), allocatable :: gas(:)
    end type
    type(capi_gas_t), allocatable, target :: c_gases(:)
    type(c_char_p), allocatable, target :: char_pp(:)

    public :: iapws_g704_capi_kh, iapws_g704_capi_kd
    public :: iapws_g704_capi_ngases
    public :: iapws_g704_capi_gases

contains

!> @brief Compute the henry constant for a given temperature.
!! @param[in] T Temperature in °C as 1d-array.
!! @param[in] gas Gas.
!! @param[in] heavywater Flag if D2O (1) is used or H2O(0).
!! @param[in] k Henry constant as 1d-array. Filled with NaNs if gas not found.
!! @param[in] size_gas Size of the gas string.
!! @param[in] size_T Size of the T and k 1d-arrays.
subroutine iapws_g704_capi_kh(T, gas, heavywater, k, size_gas, size_T)bind(C)
    implicit none
    !! arguments
    type(c_ptr), value :: T
    type(c_ptr), intent(in), value :: gas
    integer(c_int), intent(in), value :: heavywater 
    type(c_ptr), intent(in), value :: k
    integer(c_int), intent(in), value :: size_gas
    integer(c_size_t), intent(in), value :: size_T
    !! local variables
    character, pointer, dimension(:) :: c2f_gas
    real(real64), pointer :: f_T(:)
    character(len=size_gas) :: f_gas
    real(real64), pointer :: f_k(:)
    integer(int32) :: i

    call c_f_pointer(gas, c2f_gas, shape=[size_gas])
    call c_f_pointer(T, f_T, shape=[size_T])
    call c_f_pointer(k, f_k, shape=[size_T])

    do i=1, size_gas
        f_gas(i:i) = c2f_gas(i)
    enddo
    call iapws_g704_kh(f_T, f_gas, heavywater, f_k)    
end subroutine

!> @brief Compute the vapor-liquid constant for a given temperature.
!! @param[in] T Temperature in °C as 1d-array.
!! @param[in] gas Gas.
!! @param[in] heavywater Flag if D2O (1) is used or H2O(0).
!! @param[in] k Vapor-liquid constant as 1d-array. Filled with NaNs if gas not found.
!! @param[in] size_gas Size of the gas string.
!! @param[in] size_T Size of the T and k 1d-arrays.
subroutine iapws_g704_capi_kd(T, gas, heavywater, k, size_gas, size_T)bind(C)
    implicit none
    !! arguments
    type(c_ptr), value :: T
    type(c_ptr), intent(in), value :: gas
    integer(c_int), intent(in), value :: heavywater 
    type(c_ptr), intent(in), value :: k
    integer(c_int), intent(in), value :: size_gas
    integer(c_size_t), intent(in), value :: size_T
    !! local variables
    character, pointer, dimension(:) :: c2f_gas
    real(real64), pointer :: f_T(:)
    character(len=size_gas) :: f_gas
    real(real64), pointer :: f_k(:)
    integer(int32) :: i

    call c_f_pointer(gas, c2f_gas, shape=[size_gas])
    call c_f_pointer(T, f_T, shape=[size_T])
    call c_f_pointer(k, f_k, shape=[size_T])

    do i=1, size_gas
        f_gas(i:i) = c2f_gas(i)
    enddo
    call iapws_g704_kd(f_T, f_gas, heavywater, f_k)    
end subroutine

!> @brief Returns the number of gases.
!! @param[in] heavywater Flag if D2O (1) is used or H2O(0).
!! @return n Number of gases.
pure function iapws_g704_capi_ngases(heavywater)bind(C)result(n)
    implicit none
    ! arguments
    integer(c_int), intent(in), value :: heavywater
    ! return
    integer(c_int) :: n

    n = iapws_g704_ngases(heavywater)
end function

!> @brief Return the available gases.
!! @param[in] heavywater Flag if D2O (1) is used or H2O(0).
!! @return gases Available gases.
function iapws_g704_capi_gases(heavywater)bind(C)result(gases)
    implicit none
    ! arguments
    integer(c_int), intent(in), value :: heavywater
    ! return
    type(c_ptr) :: gases
    ! variables
    integer(int32) :: i, j, ngas, n

    type(iapws_g704_gas_t), pointer :: f_gases(:)
    f_gases => iapws_g704_gases(heavywater)
    ngas = size(f_gases)

    if(allocated(c_gases))then
        deallocate(c_gases)
    endif
    allocate(c_gases(ngas))

    if(allocated(char_pp))then
        deallocate(char_pp)
    endif
    allocate(char_pp(ngas))

    do i=1, ngas
        if(allocated(c_gases(i)%gas))then
            deallocate(c_gases(i)%gas)
        endif
        n = len(f_gases(i)%gas)
        allocate(c_gases(i)%gas(n+1))
        do j=1, n
            c_gases(i)%gas(j) = f_gases(i)%gas(j:j)
        enddo
        c_gases(i)%gas(n+1) = c_null_char
        char_pp(i)%p = c_loc(c_gases(i)%gas)
    enddo
    gases = c_loc(char_pp)
end function

end module