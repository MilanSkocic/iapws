! SPDX-License-Identifier: MIT

!=======================================================================
! MODULE: IAPWS__API
!=======================================================================
module iapws__api
    !! API.
    use iapws__common
    use iapws__g704
    use iapws__r797
    use iapws__r1124
    private


!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
! PUBLIC
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!{{{
public :: r1_v, r1_u, r1_s, r1_h, r1_cp, r1_cv, r1_w            ! R797
public :: wp, wr, wph
!}}}
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

contains

!------------------------------------------------------------------------------
! SUBROUTINE: WP()
!------------------------------------------------------------------------------
!{{{
pure subroutine wp(p, T, prop, res) 
    !! Compute water properties at pressure p in MPa and temperature T in Kelvin.
    
    ! The adequate region is selected according to p and T.
    !
    ! Available properties:
    !     * v: specific volume in m3/kg
    !     * u: specific internal energy in kJ/kg
    !     * s: specific entropy in kJ/kg 
    !     * h: specific enthalpy in kJ/kg/K
    !     * cp: specific isobaric heat capacity in kJ/kg/K
    !     * cv: specific isochoric heat capacity in kJ/kg/K
    !     * w: speed of sound in m/s

    ! parameters
    real(dp), intent(in) :: p(:)                 !! Pressure in MPa.
    real(dp), intent(in) :: T(:)                 !! Pressure in K.
    character(len=*), intent(in) :: prop         !! Property (v, u, s, h, cp, cv, w)
    real(dp), intent(out) :: res(:)              !! Filled with NaN if no adequate region is found.

    ! variables
    logical :: is1r
    integer(int32) :: i
    integer(int32) :: regions(size(p))
    procedure(rai), pointer :: fptr

    res = ieee_value(1.0_dp, ieee_quiet_nan)

    regions = find_region(p, T)
    is1r = is1region(regions) 

    if(is1r .eqv. .true.)then
        fptr => get_r(regions(1))
        if(associated(fptr)) then
            call fptr(p, T, prop, res) 
        end if
    else
        do i=1, size(regions)
            fptr => get_r(regions(i))
            if(associated(fptr)) then
                call fptr(p, T, prop, res) 
            end if
        end do
    end if
end subroutine
!}}}
!------------------------------------------------------------------------------

!------------------------------------------------------------------------------
! SUBROUTINE: WR()
!------------------------------------------------------------------------------
!{{{
pure subroutine wr(p, T, res) 
    !! Get the water region corresponding to p and T.

    ! parameters
    real(dp), intent(in)        :: p(:)           !! Pressure in MPa.
    real(dp), intent(in)        :: T(:)           !! Temperature in K.
    integer(int32), intent(out) :: res(:)         !! Region 1 to 5 if found or -1.

    res = find_region(p, T)
end subroutine
!}}}

!------------------------------------------------------------------------------
! SUBROUTINE: WPH()
!------------------------------------------------------------------------------
!{{{
pure subroutine wph(p, T, res) 
    !! Get the water phase corresponding to p and T.
    
    ! parameters
    real(dp), intent(in)          :: p(:)     !! pressure in MPa.
    real(dp), intent(in)          :: T(:)     !! Temperature in K.
    character(len=1), intent(out) :: res(:)   !! Phases: l(liquid), v(VAPOR), c(SUPER CRITICAL), s(SATURATION), n(UNKNOWN).

    res = find_phase(p, T)
end subroutine
!}}}
! ------------------------------------------------------------------------------

end module iapws__api
