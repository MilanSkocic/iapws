! SPDX-License-Identifier: MIT

!=======================================================================
! MODULE: IAPWS__CAPI
!=======================================================================
module iapws__capi
!! C API.
use iapws__common
use iapws__api
implicit none


contains

! ------------------------------------------------------------------------------
subroutine capi_wp(p, T, prop, res, N, len)bind(C, name="iapws_r797_wp")
    !! C API.
    
    !! Available properties:
    !!     * v: specific volume in m3/kg
    !!     * u: specific internal energy in kJ/kg
    !!     * s: specific entropy in kJ/kg 
    !!     * h: specific enthalpy in kJ/kg/K
    !!     * cp: specific isobaric heat capacity in kJ/kg/K
    !!     * cv: specific isochoric heat capacity in kJ/kg/K
    !!     * w: speed of sound in m/s
   
    ! parameters
    integer(c_int), intent(in), value    :: len         !! Size of the prop string.
    integer(c_size_t), intent(in), value :: N           !! Size of T and p.
    real(c_double), intent(in)           :: p(N)        !! Pressure in MPa.
    real(c_double), intent(in)           :: T(N)        !! Temperature in K.
    type(c_ptr), intent(in), value       :: prop        !! Water property.
    real(c_double), intent(out)          :: res(N)      !! Result. Filled with NaNs if gas not found.
    
    ! variables
    character, pointer, dimension(:) :: cprop
    character(len=len) :: fprop
    integer(int32) :: i

    call c_f_pointer(prop, cprop, shape=[len])

    do i=1, len
        fprop(i:i) = cprop(i)
    enddo

    call wp(p, T, fprop, res)
end subroutine

! ------------------------------------------------------------------------------
subroutine capi_wr(p, T, res, N)bind(C, name="iapws_r797_wr")
    !! C API.

    ! parameters
    integer(c_size_t), intent(in), value :: N           !! Size of T and p.
    real(c_double), intent(in)           :: p(N)        !! Pressure in MPa.
    real(c_double), intent(in)           :: T(N)        !! Temperature in K.
    integer(c_int), intent(out)          :: res(N)      !! Regions.

    call wr(p, T, res)
end subroutine

! ------------------------------------------------------------------------------
subroutine capi_wph(p, T, res, N)bind(C, name="iapws_r797_wph")
    !! C API.

    ! parameters
    integer(c_size_t), intent(in), value          :: N           !! Size of T and p.
    real(c_double), intent(in)                    :: p(N)        !! Pressure in MPa.
    real(c_double), intent(in)                    :: T(N)        !! Temperature in K.
    character(len=1, kind=c_char), intent(out)     :: res(N)      !! Regions.

    call wph(p, T, res)
end subroutine
! ------------------------------------------------------------------------------

end module iapws__capi
