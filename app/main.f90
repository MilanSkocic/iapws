program iapwscli
    use iso_fortran_env, only: output_unit
    use M_CLI2, only: set_args, iget, lget
    use M_CLI2, only: args=>unnamed, get_subcommand, set_mode
    use stdlib_optval
    use iapws
    use iapws__common

    character(len=*), parameter :: name="iapws"
    character(len=:),allocatable, target  :: help_text(:)
    character(len=:),allocatable, target  :: version_text(:)

    integer :: i
    character(len=3) :: s

    version_text=[character(len=80) :: &
        'PROGRAM:      '//name//'                                              ', &
        'DESCRIPTION:  Command line interface for ciaaw                        ', &
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
    call set_args('', help_text, version_text) 

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
