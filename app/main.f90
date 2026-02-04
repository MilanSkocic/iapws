program iapwscli
    use iso_fortran_env, only: output_unit
    use M_CLI2, only: set_args, iget, lget, get_args
    use M_CLI2, only: args=>unnamed, get_subcommand, set_mode
    use stdlib_optval
    use stdlib_codata, only: Mu=>MOLAR_MASS_CONSTANT
    use iapws
    use iapws__common
    use ciaaw, only: get_saw, get_naw

    character(len=*), parameter :: name="iapws"
    character(len=:),allocatable, target  :: help_text(:)
    character(len=:),allocatable, target  :: version_text(:)

    integer :: i,j,k
    character(len=3) :: s
    real(dp), allocatable :: kr(:), T(:), p(:)
    real(dp) :: k2(1)
    character(len=:), allocatable :: gas(:)
    integer :: heavywater

    type mm
        character(len=5) :: x
        real(dp) :: M
    end type

    real(dp) :: M_H, M_O, M_C, M_N, M_S, M_F, M_D
    real(dp) :: M_He, M_Ne, M_Ar, M_Kr, M_Xe 
    real(dp) :: M_H2, M_D2, M_N2, M_O2, M_CO, M_CO2 
    real(dp) :: M_H2S, M_CH4, M_C2H6, M_SF6
    real(dp) :: M_H2O, M_D2O
    real(dp) :: M_solvent
    
    M_H = get_saw('H')
    M_O = get_saw('O')
    M_C = get_saw('C')
    M_N = get_saw('N')
    M_S = get_saw('S')
    M_F = get_saw('F')
    M_D = get_naw('H', A=2)
    
    M_He = get_saw('He') * Mu%value*1d3
    M_Ne = get_saw('Ne') * Mu%value*1d3
    M_Ar = get_saw('Ar') * Mu%value*1d3
    M_Kr = get_saw('Kr') * Mu%value*1d3
    M_Xe = get_saw('Xe') * Mu%value*1d3
    M_H2 = 2*M_H * Mu%value*1d3
    M_D2 = 2*M_D * Mu%value*1d3
    M_N2 = 2*M_N * Mu%value*1d3
    M_O2 = 2*M_O * Mu%value*1d3
    M_CO2 = (M_C + 2*M_O) * Mu%value*1d3
    M_H2S = (2*M_H + M_S) * Mu%value*1d3
    M_CH4 = (M_C + 4*M_H) * Mu%value*1d3
    M_C2H6 = (2*M_C + 6*M_H) * Mu%value*1d3
    M_SF6 = (M_S + 6*M_F) * Mu%value*1d3
    M_H2O = (2*M_H+M_O) * Mu%value*1d3
    M_D2O = (2*M_D+M_O) * Mu%value*1d3

    version_text=[character(len=80) :: &
        'PROGRAM:      '//name//'                                              ', &
        'DESCRIPTION:  Compute light and heavy water properties.               ', &
        'VERSION:      '//get_version()//'                                     ', &
        'AUTHOR:       M. Skocic                                               ', &
        'LICENSE:      MIT                                                     ', &
        '' ]

    help_text=[character(len=80) :: &
        'NAME                                                                  ', &
        '  '//name//' - Compute light and heavy water properties.               ', &
        '                                                                      ', &
        'SYNOPSIS                                                              ', &
        '  '//name//' [OPTION...]                                ', &
        '                                                                      ', &
        'DESCRIPTION                                                           ', &
        '  '//name//' is a command line interface which computes the properties', &
        '  of light and heavy water according to IAPWS.                        ', &
        '                                                                      ', &
        'OPTIONS                                                               ', &
        '  --colnames, -c   Show the headers in the outputs.                 ', &
        '  --usage, -u      Show usage text and exit.                        ', &
        '  --help, -h       Show help text and exit.                         ', &
        '  --verbose, -V    Display additional information when available.   ', &
        '  --version, -v    Show version information and exit.               ', &
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
    call set_args('--temperature:T 25.0 --pressure:P 0.1 --gas:g O2 &
                   --kH --kD --D2O --colnames:c', &
                   help_text, version_text) 
    heavywater = 0
    call get_args('T', T)
    call get_args('g', gas)
    call get_args('P', p)
    

    if(lget('kH'))then
        call print_kH(T, p, gas, heavywater, lget('c'))
    end if
    
    if(lget('kD'))then
        allocate(kr(size(T)))
        do k=1, size(gas)
            call kd(T+273.15_dp, trim(gas(k)), heavywater, kr)
            do i=1, size(T)
                write(output_unit, '(SP,F14.2,X,EN24.6)') T(i), kr(i)
            end do
        end do
        deallocate(kr)
    end if
    
contains

function get_mm(x)result(r)
    character(len=*), intent(in) :: x
    real(dp) :: r
    select case (trim(x))
        case ('He')
            r = M_He
        case ('Ne')
            r = M_Ne
        case ('Ar')
            r = M_Ar
        case ('Kr')
            r = M_Kr
        case ('Xe')
            r = M_Xe
        case ('H2')
            r = M_H2
        case ('D2')
            r = M_D2
        case ('N2')
            r = M_N2
        case ('O2')
            r = M_O2
        case ('CO2')
            r = M_CO2
        case ('H2S')
            r = M_H2S 
        case ('CH4')
            r = M_CH4 
        case ('C2H6')
            r = M_C2H6
        case ('SF6')
            r = M_SF6
        case ('H2O')
            r = M_H2O
        case ('D2O')
            r = M_D2O
        case default
            r = 0.0_dp
    end select
end function

subroutine print_kH(T, p, gas, heavywater,header)
    real(dp), intent(in) :: T(:), p(:)
    character(len=*), intent(in) :: gas(:)
    integer, intent(in) :: heavywater
    logical, intent(in) :: header

    real(dp), allocatable :: kr(:)
    real(dp) :: M_solvent
    integer :: i,j,k
    logical :: h

    character(len=16) :: headers(5)
    character(len=32) :: fmt
    character(len=15) :: s1, s2, s3, s4, s5

    h = optval(header, .false.)
    
    M_solvent = M_H2O
    if(heavywater == 1) then 
        M_solvent = M_D2O
    end if

    headers = [character(len=15) :: 'gas', 'T-degC', 'P-MPa', 'kH-MPa', 'S-ppm']
    fmt = '(A5, A15, A15, A15, A15)'
    
    if(h) write(output_unit, fmt) headers

    allocate(kr(size(T)))
    do k=1, size(gas)
        call kh(T+273.15_dp, trim(gas(k)), heavywater, kr)
        do i=1, size(T)
            do j=1, size(P)
                write(s1, '(A5)') gas(k)
                write(s2, '(F14.2)') T(i) 
                write(s3, '(F14.6)') p(i) 
                write(s4, '(EN14.2)') kr(i) 
                write(s5, '(EN14.2)') 1/kr(i) * get_mm(gas(k)) / M_solvent * 1d6 * P(j)
                write(output_unit, fmt) &
                    adjustl(s1), &
                    adjustl(s2), &
                    adjustl(s3), &
                    adjustl(s4), &
                    adjustl(s5)
            end do
        end do
    end do
    deallocate(kr)
end subroutine

end program
