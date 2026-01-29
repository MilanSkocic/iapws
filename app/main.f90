program iapwscli
    use iso_fortran_env, only: output_unit
    use M_CLI2, only: set_args, iget, lget, get_args
    use M_CLI2, only: args=>unnamed, get_subcommand, set_mode
    use stdlib_optval
    use iapws
    use iapws__common
    use codata, only: Mu=>MOLAR_MASS_CONSTANT
    use ciaaw, only: get_saw

    character(len=*), parameter :: name="iapws"
    character(len=:),allocatable, target  :: help_text(:)
    character(len=:),allocatable, target  :: version_text(:)

    integer :: i
    character(len=3) :: s
    real(dp), allocatable :: k(:), T(:)
    real(dp) :: k2(1)
    character(len=:), allocatable :: gas
    integer :: heavywater

    real(dp) :: M_H, M_O, M_C
    real(dp) :: M_H2O, M_H2, M_O2, M_CO2
    
    M_H = get_saw('H')
    M_O = get_saw('O')
    M_C = get_saw('C')

    M_H2 = 2*M_H * Mu%value*1d3
    M_O2 = 2*M_O * Mu%value*1d3
    M_H2O = (2*M_H+M_O) * Mu%value*1d3


    version_text=[character(len=80) :: &
        'PROGRAM:      '//name//'                                              ', &
        'DESCRIPTION:  Command line interface for iapws.                       ', &
        'VERSION:      '//get_version()//'                                     ', &
        'AUTHOR:       M. Skocic                                               ', &
        'LICENSE:      MIT                                                     ', &
        '' ]

    help_text=[character(len=80) :: &
        'NAME                                                                  ', &
        '  '//name//' - Command line for iapws                                 ', &
        '                                                                      ', &
        'SYNOPSIS                                                              ', &
        '  '//name//' [OPTIONS] ARGS ...                                 ', &
        '                                                                      ', &
        'DESCRIPTION                                                           ', &
        '  '//name//' is a command line interface which provides ...    ', &
        '                                                                      ', &
        'OPTIONS                                                               ', &
        '  o --usage, -u      Show usage text and exit.                        ', &
        '  o --help, -h       Show help text and exit.                         ', &
        '  o --verbose, -V    Display additional information when available.   ', &
        '  o --version, -v    Show version information and exit.               ', &
        '                                                                      ', &
        'EXAMPLE                                                               ', &
        '  Minimal example                                                     ', &
        '                                                                      ', &
        '      iapws                                                           ', &
        '                                                                      ', &
        'SEE ALSO                                                              ', &
        '  ciaaw(3), codata(3)                                                 ', &
        '' ]
    
    call set_mode('strict')
    call set_args('--temperature:T 25.0 --pressure:P 0.1 --gas:g O2 --kH --kD --D2O', help_text, version_text) 
    heavywater = 0
    call get_args('T', T)
    call get_args('g', gas)

    if(lget('D2O')) heavywater=1

    if(lget('kH'))then
        allocate(k(size(T)))
        call kh(T+273.15_dp, trim(gas), heavywater, k)
        do i=1, size(T)
            write(output_unit, '(SP,F14.2,X,EN24.6)') T(i), k(i)
        end do
        deallocate(k)
    end if
    
    if(lget('kD'))then
        allocate(k(size(T)))
        call kd(T+273.15_dp, trim(gas), heavywater, k)
        do i=1, size(T)
            write(output_unit, '(SP,F14.2,X,EN24.6)') T(i), k(i)
        end do
        deallocate(k)
    end if
    
contains

subroutine print_text(char_fp)
    ! Print text pointed by char_fp.
    character(len=:), pointer, intent(in) :: char_fp(:)
    integer :: i
    do i=1, size(char_fp), 1
        write (OUTPUT_UNIT, '(A)') char_fp(i)
    end do
end subroutine
end program
