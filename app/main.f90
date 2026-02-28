program iapwscli
    use iso_fortran_env, only: output_unit, error_unit
    use M_CLI2, only: set_args, set_mode, iget, lget, get_args, dgets, &
                      args=>unnamed, get_subcommand, set_mode
    use stdlib_optval
    use stdlib_codata, only: Mu=>MOLAR_MASS_CONSTANT
    use iapws
    use iapws__common
    use ciaaw, only: get_saw, get_naw

    character(len=*), parameter :: name="iapws"
    character(len=:),allocatable, target  :: help_text(:)
    character(len=:),allocatable, target  :: version_text(:)
    character(len=32) :: cmd

    real(dp), allocatable :: T(:), f(:), x2(:), p(:)
    character(len=:), allocatable :: gas(:)
    integer :: heavywater
    
    real(dp) :: M_H, M_O, M_C, M_N, M_S, M_F, M_D
    real(dp) :: M_He, M_Ne, M_Ar, M_Kr, M_Xe 
    real(dp) :: M_H2, M_D2, M_N2, M_O2, M_CO, M_CO2 
    real(dp) :: M_H2S, M_CH4, M_C2H6, M_SF6
    real(dp) :: M_H2O, M_D2O

    real(dp), parameter :: zero_Celsius = 273.15_dp

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
        '  '//name//' - Compute light and heavy water properties.              ', &
        '                                                                      ', &
        'SYNOPSIS                                                              ', &
        '  '//name//' SUBCOMMAND [OPTION...]                                   ', &
        '                                                                      ', &
        'DESCRIPTION                                                           ', &
        '  '//name//' is a command line interface for computing properties', &
        '  of light and heavy water according to IAPWS.                        ', &
        '                                                                      ', &
        'SUBCOMMANDS                                                           ', &
        '  Valid subcommands are:                                              ', &
        "    + kh    Compute the Henry's constant for gases in H2O or D2O.        ", &
        '            The default behavior is to compute the constant kH for O2', &
        '            at 25°C.See options.', &
        '            See options.', &
        '    + kd    Compute the vapor-liquid distribution constant for gases  ', &
        '            in H2O or D2O.', &
        '            The default behavior is to compute the constant kD for H2', &
        '            at 25°C.', &
        '            See options.', &
        '    + psat  Compute the saturation pressure.', &
        '            The default behavior is to compute psat at 25°C. ', &
        '            See options.',&
        '    + Tsat  Compute the saturation temperature.', &
        '            The default behavior is to compute Tsat at 1 bar. ', &
        '            See options.',&
        '    + wp    Compute water properties for regions 1 to 5.      ', &
        '            The default behavior is to compute the properties         ', &
        '            at 25°C and 1 bar.                                         ', &
        '            WARNING: Currently, only region 1 is supported.    ', &
        '                                                              ', &
        '  Their syntax is:                                            ', &
        '    + kh     [OPTION...]                                      ', &
        '    + kd     [OPTION...]                                      ', &
        '    + psat   [OPTION...]                                      ', &
        '    + Tsat   [OPTION...]                                      ', &
        '    + wp     [OPTION...]                                      ', &
        '                                                              ', &
        'OPTIONS                                                               ', &
        '                                                                      ', &
        'kh:                                                                   ', &
        '  --temperature, -T TEMPERATURE...  Temperature in °C. Default to 25°C.', &
        '  --fugacity, -f FUGACITY...        Liquid-phase fugacity in MPa.     ', & 
        '                                    Default to 1 bar.', &
        '  --gases, -g GAS...                Gases for which to compute kH.    ', & 
        '                                    Default to O2.', &
        '  --D2O                             Set heavywater as the solvent.    ', &
        '  --listgases                       Display available gases for       ', & 
        '                                    computing kH.', &
        '                                                                      ', &
        'kd:                                                                   ', &
        '  --temperature, -T TEMPERATURE...  Temperature in °C. Default to 25°C.', &
        '  --x2, -x x2...                    Molar fraction of gas in water.   ', &
        '                                    Default to 1e-9.', &
        '  --gases, -g GAS...                Gases for which to compute kD.    ', &
        '                                    Default to H2.', &
        '  --D2O,                            Set heavywater as the solvent.', &
        '  --listgases                       Display available gases for       ', &
        '                                    computing kD.', &
        '                                                                      ', &
        'psat:                                                                   ', &
        '  --temperature, -T TEMPERATURE...  Temperature in °C. Default to 25°C.', &
        '                                                                      ', &
        'Tsat:                                                                   ', &
        '  --pressure, -p PRESSURE...        Pressure in bar. Default to 1 bar.', &
        '                                                                      ', &
        'wp:                                                           ', &
        '  --temperature, -T TEMPERATURE...  Temperature in °C. Default to 25°C.', &
        '  --pressure, -p PRESSURE...        Pressure in bar. Default to 1 bar.', &
        '                                                                      ', &
        'all:                                                                  ', &
        '  --usage, -u        Show usage text and exit.         ', &
        '  --help, -h         Show help text and exit.          ', &
        '  --verbose, -V      Display additional information.', &
        '  --version, -v      Show version information and exit.          ', &
        '                                                                      ', &
        'NOTES                                                                 ', &
        '                                                                      ', &
        '  You may replace the default options from a file if your first       ', &
        '  options begin with @file.                                           ', &
        '  Initial options will then be read from the "response file"          ', &
        '  "file.rsp" in the current directory.                                ', &
        '                                                                      ', &
        '  If "file" does not exist or cannot be read, then an error occurs and', &
        '  the program stops. Each line of the file is prefixed with "options"', &
        '  and interpreted as a separate argument. The file itself may not'  , &
        '  contain @file arguments. That is, it is not processed recursively.', &
        '                                                                      ', &
        '  For more information on response files see                          '  , &
        '  https://urbanjost.github.io/M_CLI2/set_args.3m_cli2.html            '  , &
        '                                                                      ', &
        'EXAMPLE                                                               ', &
        '  Minimal example                                                     ', &
        '                                                                      ', &
        '      iapws kh -T 25,100 -f 1,0.2 -g O2,H2                       ', &
        '      iapws kd -T 25,100 -x2 1d-9,1d-6 -g O2,H2                       ', &
        '                                                                      ', &
        'SEE ALSO                                                              ', &
        '  ciaaw(3), codata(3)                                                 ', &
        '' ]
    
    call set_mode('strict')
    call set_mode('response_file')
    cmd = get_subcommand()

    select case (cmd)
        case ("kh")
            call set_args('--temperature:T 25.0 --fugacity:f 1 --gas:g O2 --D2O --listgases', &
                           help_text, version_text) 
            heavywater = 0
            call get_args('g', gas)
            call get_args('f', f)
            call get_args('T', T)

            if(lget('D2O'))then
                heavywater = 1
            else
                heavywater = 0
            end if
            
            if(lget('listgases')) then
                write(output_unit, '(A)') gases2(heavywater)
                stop 
            end if

            call print_kh(T, f, gas, heavywater)


        case ('kd')
            call set_args('--temperature:T 25.0 --x2:x 1.0d-9 --gas:g H2 --D2O --listgases', &
                           help_text, version_text) 
            heavywater = 0
            call get_args('g', gas)
            call get_args('x', x2)
            call get_args('T', T)

            if(lget('D2O'))then
                heavywater = 1
            else
                heavywater = 0
            end if
            
            if(lget('listgases')) then
                write(output_unit, '(A)') gases2(heavywater)
                stop
            end if
            
            call print_kd(T, x2, gas, heavywater)

        case ('psat')
            call set_args('--temperature:T 25.0',  help_text, version_text) 
            call get_args('T', T)

            call print_psat(T)
        
        case ('Tsat')
            call set_args('--pressure:p 1.0',  help_text, version_text) 
            call get_args('p', p)

            call print_Tsat(p)

        case('wp')
            call set_args('--temperature:T 25.0, --pressure:p 1.0 --psat:F', help_text, version_text)
            call get_args('T', T)
            call get_args('p', p)
            if(size(p) /= size(T))then
                write(output_unit, '(A)') 'T and p must have the same number of elements.'
                stop
            end if
            call print_wp(p, T)
            
        case default
            call set_args('', help_text, version_text) 
            write(output_unit, '(A)') 'Enter a valid command. See --help.'
            stop
    end select
    
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
        case ('CO')
            r = M_CO
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

subroutine print_kh(T, f, gas, heavywater)
    real(dp), intent(in), contiguous :: T(:), f(:)
    character(len=*), intent(in), contiguous :: gas(:)
    integer, intent(in) :: heavywater

    real(dp), allocatable :: kr(:)
    real(dp) :: M_solvent
    integer :: i,j,k

    character(len=16) :: headers(6)
    character(len=32) :: fmt
    character(len=15) :: s1, s2, s3, s4, s5, s6

    
    M_solvent = M_H2O
    if(heavywater == 1) then 
        M_solvent = M_D2O
    end if

    headers = [character(len=15) :: 'gas', 'T-degC', 'f-bar', 'kH-MPa', 'x2-a.u.', 's-ppm']
    fmt = '(A5, 5A15)'
    
    write(output_unit, fmt) headers

    allocate(kr(size(T)))
    do k=1, size(gas)
        call kh(T+zero_Celsius, trim(gas(k)), heavywater, kr)
        do i=1, size(T)
            do j=1, size(f)
                write(s1, '(A5)') gas(k)
                write(s2, '(F14.2)') T(i) 
                write(s3, '(F14.3)') f(j) 
                write(s4, '(SP, EN14.2)') kr(i) 
                write(s5, '(SP, EN14.2)') 1/kr(i) * (f(j)/10.0_dp) ! x2
                write(s6, '(SP, F14.2)') 1/kr(i) * get_mm(gas(k)) / M_solvent * 1d6 * (f(j)/10.0_dp) ! solubility in liquid
                write(output_unit, fmt) &
                    adjustl(s1), &
                    adjustl(s2), &
                    adjustl(s3), &
                    adjustl(s4), &
                    adjustl(s5), &
                    adjustl(s6)
            end do
        end do
    end do
    deallocate(kr)
end subroutine

subroutine print_kd(T, x2, gas, heavywater)
    real(dp), intent(in), contiguous :: T(:), x2(:)
    character(len=*), intent(in), contiguous :: gas(:)
    integer, intent(in) :: heavywater

    real(dp), allocatable :: kr(:)
    real(dp) :: M_solvent
    integer :: i,j,k

    character(len=16) :: headers(5)
    character(len=32) :: fmt
    character(len=15) :: s1, s2, s3, s4, s5
    
    M_solvent = M_H2O
    if(heavywater == 1) then 
        M_solvent = M_D2O
    end if

    headers = [character(len=15) :: 'gas', 'T-degC', 'x2-a.u.', 'kD', 'y2-a.u.']
    fmt = '(A5, 4A15)'
    
    write(output_unit, fmt) headers

    allocate(kr(size(T)))
    do k=1, size(gas)
        call kd(T+zero_Celsius, trim(gas(k)), heavywater, kr)
        do i=1, size(T)
            do j=1, size(x2)
                write(s1, '(A5)') gas(k)
                write(s2, '(SP, F14.2)') T(i) 
                write(s3, '(SP, ES14.3)') x2(j) 
                write(s4, '(SP, ES14.2)') kr(i) 
                write(s5, '(SP, ES14.2)') x2(j) * kr(i) 
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

subroutine print_psat(T)
    real(dp), intent(in), contiguous :: T(:)
    
    real(dp), allocatable :: p(:)
    integer :: i

    character(len=20) :: headers(2)
    character(len=32) :: fmt
    character(len=20) :: s1, s2
    
    headers = [character(len=15) :: 'T-degC', 'psat-bar']
    fmt = '(A20, A20)'
    
    write(output_unit, fmt) headers

    allocate(p(size(T)))
    call psat(T+zero_Celsius, p)
    do i=1, size(T)
        write(s1, '(SP, F14.2)') T(i)
        write(s2, '(SP, F20.6)') p(i)*10.0_dp 
        write(output_unit, fmt) adjustl(s1), adjustl(s2)
    end do
    deallocate(p)
end subroutine

subroutine print_Tsat(p)
    real(dp), intent(in), contiguous :: p(:)
    
    real(dp), allocatable :: T(:)
    integer :: i

    character(len=20) :: headers(2)
    character(len=32) :: fmt
    character(len=20) :: s1, s2
    
    headers = [character(len=15) :: 'psat-bar', 'T-degC']
    fmt = '(A20, A20)'
    
    write(output_unit, fmt) headers

    allocate(T(size(p)))
    call Tsat(p/10.0_dp,T)
    do i=1, size(p)
        write(s1, '(SP, F20.6)') p(i)
        write(s2, '(SP, F14.2)') T(i) - zero_Celsius
        write(output_unit, fmt) adjustl(s1), adjustl(s2)
    end do
    deallocate(T)
end subroutine

subroutine print_wp(p, T)
    real(dp), intent(in), contiguous :: T(:)
    real(dp), intent(in), contiguous :: p(:)
    
    integer, allocatable :: r(:)
    character(len=1), allocatable :: ph(:)
    real(dp), allocatable :: v(:), u(:), s(:), h(:), cp(:), cv(:), w(:)
    integer :: i, n

    character(len=32) :: headers(12)
    character(len=64) :: fmt
    character(len=32) :: s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12

    headers = [character(len=32) :: 'T-degC', 'p-bar', 'r', 'p', &
                                    'v-m3.kg^-1', 'rho-kg.m^-3', &
                                    'u-kJ.kg^-1', 's-kJ.kg^-1', 'h-kJ.kg^-1.K^-1', &
                                    'cp-kJ.kg^-1.K^-1', 'cv-kJ.kg^-1.K^-1', 'w-m.s^-1']
    fmt = '(A10, A15, A5, A5, A15, A15, A15, A15, A18, A18, A18, A15)'

    write(output_unit, fmt) headers

    n = size(p)
    allocate(r(n))
    allocate(ph(n))
    allocate(v(n))
    allocate(u(n))
    allocate(s(n))
    allocate(h(n))
    allocate(cp(n))
    allocate(cv(n))
    allocate(w(n))

    call wr(p/10.0_dp, T+zero_Celsius, r)
    call wph(p/10.0_dp, T+zero_Celsius, ph)
    call wp(p/10.0_dp, T+zero_Celsius, 'v', v)
    call wp(p/10.0_dp, T+zero_Celsius, 'u', u)
    call wp(p/10.0_dp, T+zero_Celsius, 's', s)
    call wp(p/10.0_dp, T+zero_Celsius, 'h', h)
    call wp(p/10.0_dp, T+zero_Celsius, 'cp', cp)
    call wp(p/10.0_dp, T+zero_Celsius, 'cv', cv)
    call wp(p/10.0_dp, T+zero_Celsius, 'w', w)
    do i=1, size(p), 1
        write(s1, '(SP, F10.2)') T(i)
        write(s2, '(SP, F15.6)') p(i)
        write(s3, '(I5)') r(i)
        write(s4, '(A5)') ph(i)
        write(s5, '(SP, EN15.6)') v(i)
        write(s6, '(SP, F15.4)') 1.0_dp/v(i)
        write(s7, '(SP, EN15.4)') u(i)
        write(s8, '(SP, EN15.4)') s(i)
        write(s9, '(SP,  EN20.4)') h(i)
        write(s10, '(SP, EN20.4)') cp(i)
        write(s11, '(SP, EN20.4)') cv(i)
        write(s12, '(SP, EN15.4)') w(i)
        write(output_unit, fmt) adjustl(s1), adjustl(s2), &
                                adjustl(s3), adjustl(s4), &
                                adjustl(s5), adjustl(s6), &
                                adjustl(s7), adjustl(s8), &
                                adjustl(s9), adjustl(s10), &
                                adjustl(s11), adjustl(s12)
    end do

    deallocate(r)
    deallocate(ph)
    deallocate(v)
    deallocate(u)
    deallocate(h)
    deallocate(cp)
    deallocate(cv)
    deallocate(w)
end subroutine

end program
