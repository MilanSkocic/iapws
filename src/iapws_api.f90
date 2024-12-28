module iapws__api
    !! API
    !! See [specs](../page/specs/api.html)
    use iapws__version
    private
    
    character(len=:), allocatable, target :: version_f

    public:: get_version
    
contains

! VERSION
function get_version()result(fptr)
    !! Get the version
    implicit none
    character(len=:), pointer :: fptr    !! Fortran pointer to a string indicating the version..

    if(allocated(version_f))then
        deallocate(version_f)
    endif
    allocate(character(len=len(version)) :: version_f)
    version_f = version
    fptr => version_f    
end function
! ------------------------------------------------------------------------------
end module iapws__api
