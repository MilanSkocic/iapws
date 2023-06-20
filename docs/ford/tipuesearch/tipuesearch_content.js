var tipuesearch = {"pages":[{"title":" iapws ","text":"iapws This is the documentation of the Fortran code. Go back to the main documentation click here Developer Info Milan Skocic","tags":"home","loc":"index.html"},{"title":"iapws_g704_gas_t – iapws ","text":"type, public :: iapws_g704_gas_t Derived type containing a allocatable string for representing a gas. Contents Variables gas Components Type Visibility Attributes Name Initial character(len=:), public, allocatable :: gas Gas","tags":"","loc":"type/iapws_g704_gas_t.html"},{"title":"iapws_g704_capi_gases – iapws","text":"public function iapws_g704_capi_gases(heavywater) result(gases) bind(C) Returns the list of available gases. Arguments Type Intent Optional Attributes Name integer(kind=c_int), intent(in), value :: heavywater Flag if D2O (1) is used or H2O(0). Return Value type(c_ptr) Available gases. Contents None","tags":"","loc":"proc/iapws_g704_capi_gases.html"},{"title":"iapws_g704_capi_ngases – iapws","text":"public pure function iapws_g704_capi_ngases(heavywater) result(n) bind(C) Returns the number of gases. Arguments Type Intent Optional Attributes Name integer(kind=c_int), intent(in), value :: heavywater Flag if D2O (1) is used or H2O(0). Return Value integer(kind=c_int) Number of gases. Contents None","tags":"","loc":"proc/iapws_g704_capi_ngases.html"},{"title":"iapws_g704_capi_kd – iapws","text":"public subroutine iapws_g704_capi_kd(T, gas, heavywater, k, size_gas, size_T) bind(C) Compute the vapor-liquid constant for a given temperature. Arguments Type Intent Optional Attributes Name type(c_ptr), value :: T Temperature in °C. type(c_ptr), intent(in), value :: gas Gas. integer(kind=c_int), intent(in), value :: heavywater Flag if D2O (1) is used or H2O(0). type(c_ptr), intent(in), value :: k Vapor-liquid constant. Filled with NaNs if gas not found. integer(kind=c_int), intent(in), value :: size_gas Size of the gas string. integer(kind=c_size_t), intent(in), value :: size_T Size of T and k. Contents None","tags":"","loc":"proc/iapws_g704_capi_kd.html"},{"title":"iapws_g704_capi_kh – iapws","text":"public subroutine iapws_g704_capi_kh(T, gas, heavywater, k, size_gas, size_T) bind(C) Compute the henry constant for a given temperature. Arguments Type Intent Optional Attributes Name type(c_ptr), value :: T Temperature in °C. type(c_ptr), intent(in), value :: gas Gas. integer(kind=c_int), intent(in), value :: heavywater Flag if D2O (1) is used or H2O(0). type(c_ptr), intent(in), value :: k Henry constant. Filled with NaNs if gas not found. integer(kind=c_int), intent(in), value :: size_gas Size of the gas string. integer(kind=c_size_t), intent(in), value :: size_T Size of T and k. Contents None","tags":"","loc":"proc/iapws_g704_capi_kh.html"},{"title":"iapws_g704_gases – iapws","text":"public function iapws_g704_gases(heavywater) result(gases) Returns the list of available gases. Arguments Type Intent Optional Attributes Name integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). Return Value type( iapws_g704_gas_t ),pointer,(:) Available gases. Contents None","tags":"","loc":"proc/iapws_g704_gases.html"},{"title":"iapws_g704_gases2 – iapws","text":"public function iapws_g704_gases2(heavywater) result(gases) Returns the available gases as a string. Arguments Type Intent Optional Attributes Name integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). Return Value character(len=:),pointer Available gases Contents None","tags":"","loc":"proc/iapws_g704_gases2.html"},{"title":"iapws_g704_ngases – iapws","text":"public pure function iapws_g704_ngases(heavywater) result(n) Returns the number of gases. Arguments Type Intent Optional Attributes Name integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). Return Value integer(kind=int32) Number of gases. Contents None","tags":"","loc":"proc/iapws_g704_ngases.html"},{"title":"iapws_g704_kd – iapws","text":"public pure subroutine iapws_g704_kd(T, gas, heavywater, k) Compute the vapor-liquid constant for a given temperature. Arguments Type Intent Optional Attributes Name real(kind=real64), intent(in) :: T (:) Temperature in °C. character(len=*), intent(in) :: gas Gas. integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). real(kind=real64), intent(out) :: k (:) Vapor-liquid constant. Filled with NaNs if gas not found. Contents None","tags":"","loc":"proc/iapws_g704_kd.html"},{"title":"iapws_g704_kh – iapws","text":"public pure subroutine iapws_g704_kh(T, gas, heavywater, k) Compute the henry constant for a given temperature. Arguments Type Intent Optional Attributes Name real(kind=real64), intent(in) :: T (:) Temperature in °C. character(len=*), intent(in) :: gas Gas. integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). real(kind=real64), intent(out) :: k (:) Henry constant. Filled with NaNs if gas not found. Contents None","tags":"","loc":"proc/iapws_g704_kh.html"},{"title":"iapws – iapws","text":"Main module for the IAPWS library. Uses iapws_g704 Contents None","tags":"","loc":"module/iapws.html"},{"title":"iapws_g704_capi – iapws","text":"C API for the IAPWS module. Uses iapws_g704 iso_c_binding iso_fortran_env Contents Functions iapws_g704_capi_gases iapws_g704_capi_ngases Subroutines iapws_g704_capi_kd iapws_g704_capi_kh Functions public function iapws_g704_capi_gases (heavywater) result(gases) bind(C) Returns the list of available gases. Arguments Type Intent Optional Attributes Name integer(kind=c_int), intent(in), value :: heavywater Flag if D2O (1) is used or H2O(0). Return Value type(c_ptr) Available gases. public pure function iapws_g704_capi_ngases (heavywater) result(n) bind(C) Returns the number of gases. Arguments Type Intent Optional Attributes Name integer(kind=c_int), intent(in), value :: heavywater Flag if D2O (1) is used or H2O(0). Return Value integer(kind=c_int) Number of gases. Subroutines public subroutine iapws_g704_capi_kd (T, gas, heavywater, k, size_gas, size_T) bind(C) Compute the vapor-liquid constant for a given temperature. Arguments Type Intent Optional Attributes Name type(c_ptr), value :: T Temperature in °C. type(c_ptr), intent(in), value :: gas Gas. integer(kind=c_int), intent(in), value :: heavywater Flag if D2O (1) is used or H2O(0). type(c_ptr), intent(in), value :: k Vapor-liquid constant. Filled with NaNs if gas not found. integer(kind=c_int), intent(in), value :: size_gas Size of the gas string. integer(kind=c_size_t), intent(in), value :: size_T Size of T and k. public subroutine iapws_g704_capi_kh (T, gas, heavywater, k, size_gas, size_T) bind(C) Compute the henry constant for a given temperature. Arguments Type Intent Optional Attributes Name type(c_ptr), value :: T Temperature in °C. type(c_ptr), intent(in), value :: gas Gas. integer(kind=c_int), intent(in), value :: heavywater Flag if D2O (1) is used or H2O(0). type(c_ptr), intent(in), value :: k Henry constant. Filled with NaNs if gas not found. integer(kind=c_int), intent(in), value :: size_gas Size of the gas string. integer(kind=c_size_t), intent(in), value :: size_T Size of T and k.","tags":"","loc":"module/iapws_g704_capi.html"},{"title":"iapws_g704 – iapws","text":"Module for IAPWS G7-04 Uses ieee_arithmetic iso_fortran_env Contents Derived Types iapws_g704_gas_t Functions iapws_g704_gases iapws_g704_gases2 iapws_g704_ngases Subroutines iapws_g704_kd iapws_g704_kh Derived Types type, public :: iapws_g704_gas_t Derived type containing a allocatable string for representing a gas. Components Type Visibility Attributes Name Initial character(len=:), public, allocatable :: gas Gas Functions public function iapws_g704_gases (heavywater) result(gases) Returns the list of available gases. Arguments Type Intent Optional Attributes Name integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). Return Value type( iapws_g704_gas_t ),pointer, (:) Available gases. public function iapws_g704_gases2 (heavywater) result(gases) Returns the available gases as a string. Arguments Type Intent Optional Attributes Name integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). Return Value character(len=:),pointer Available gases public pure function iapws_g704_ngases (heavywater) result(n) Returns the number of gases. Arguments Type Intent Optional Attributes Name integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). Return Value integer(kind=int32) Number of gases. Subroutines public pure subroutine iapws_g704_kd (T, gas, heavywater, k) Compute the vapor-liquid constant for a given temperature. Arguments Type Intent Optional Attributes Name real(kind=real64), intent(in) :: T (:) Temperature in °C. character(len=*), intent(in) :: gas Gas. integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). real(kind=real64), intent(out) :: k (:) Vapor-liquid constant. Filled with NaNs if gas not found. public pure subroutine iapws_g704_kh (T, gas, heavywater, k) Compute the henry constant for a given temperature. Arguments Type Intent Optional Attributes Name real(kind=real64), intent(in) :: T (:) Temperature in °C. character(len=*), intent(in) :: gas Gas. integer(kind=int32), intent(in) :: heavywater Flag if D2O (1) is used or H2O(0). real(kind=real64), intent(out) :: k (:) Henry constant. Filled with NaNs if gas not found.","tags":"","loc":"module/iapws_g704.html"},{"title":"iapws.f90 – iapws","text":"Contents Modules iapws Source Code iapws.f90 Source Code module iapws !! Main module for the IAPWS library. use iapws_g704 end module","tags":"","loc":"sourcefile/iapws.f90.html"},{"title":"iapws_g704_capi.f90 – iapws","text":"Contents Modules iapws_g704_capi Source Code iapws_g704_capi.f90 Source Code module iapws_g704_capi !! C API for the IAPWS module. use iso_fortran_env use iso_c_binding use iapws_g704 implicit none private type , bind ( C ) :: c_char_p type ( c_ptr ) :: p end type type :: capi_gas_t character ( kind = c_char , len = 1 ), allocatable :: gas (:) end type type ( capi_gas_t ), allocatable , target :: c_gases (:) type ( c_char_p ), allocatable , target :: char_pp (:) character ( len = :), allocatable , target :: c_gases_str public :: iapws_g704_capi_kh , iapws_g704_capi_kd public :: iapws_g704_capi_ngases public :: iapws_g704_capi_gases contains subroutine iapws_g704_capi_kh ( T , gas , heavywater , k , size_gas , size_T ) bind ( C ) !! Compute the henry constant for a given temperature. implicit none ! arguments type ( c_ptr ), value :: T !! Temperature in °C. type ( c_ptr ), intent ( in ), value :: gas !! Gas. integer ( c_int ), intent ( in ), value :: heavywater !! Flag if D2O (1) is used or H2O(0). type ( c_ptr ), intent ( in ), value :: k !! Henry constant. Filled with NaNs if gas not found. integer ( c_int ), intent ( in ), value :: size_gas !! Size of the gas string. integer ( c_size_t ), intent ( in ), value :: size_T !! Size of T and k. ! variables character , pointer , dimension (:) :: c2f_gas real ( real64 ), pointer :: f_T (:) character ( len = size_gas ) :: f_gas real ( real64 ), pointer :: f_k (:) integer ( int32 ) :: i call c_f_pointer ( gas , c2f_gas , shape = [ size_gas ]) call c_f_pointer ( T , f_T , shape = [ size_T ]) call c_f_pointer ( k , f_k , shape = [ size_T ]) do i = 1 , size_gas f_gas ( i : i ) = c2f_gas ( i ) enddo call iapws_g704_kh ( f_T , f_gas , heavywater , f_k ) end subroutine subroutine iapws_g704_capi_kd ( T , gas , heavywater , k , size_gas , size_T ) bind ( C ) !! Compute the vapor-liquid constant for a given temperature. implicit none ! arguments type ( c_ptr ), value :: T !! Temperature in °C. type ( c_ptr ), intent ( in ), value :: gas !! Gas. integer ( c_int ), intent ( in ), value :: heavywater !! Flag if D2O (1) is used or H2O(0). type ( c_ptr ), intent ( in ), value :: k !! Vapor-liquid constant. Filled with NaNs if gas not found. integer ( c_int ), intent ( in ), value :: size_gas !! Size of the gas string. integer ( c_size_t ), intent ( in ), value :: size_T !! Size of T and k. ! variables character , pointer , dimension (:) :: c2f_gas real ( real64 ), pointer :: f_T (:) character ( len = size_gas ) :: f_gas real ( real64 ), pointer :: f_k (:) integer ( int32 ) :: i call c_f_pointer ( gas , c2f_gas , shape = [ size_gas ]) call c_f_pointer ( T , f_T , shape = [ size_T ]) call c_f_pointer ( k , f_k , shape = [ size_T ]) do i = 1 , size_gas f_gas ( i : i ) = c2f_gas ( i ) enddo call iapws_g704_kd ( f_T , f_gas , heavywater , f_k ) end subroutine pure function iapws_g704_capi_ngases ( heavywater ) bind ( C ) result ( n ) !! Returns the number of gases. implicit none ! arguments integer ( c_int ), intent ( in ), value :: heavywater !! Flag if D2O (1) is used or H2O(0). integer ( c_int ) :: n !! Number of gases. n = iapws_g704_ngases ( heavywater ) end function function iapws_g704_capi_gases ( heavywater ) bind ( C ) result ( gases ) !! Returns the list of available gases. implicit none ! arguments integer ( c_int ), intent ( in ), value :: heavywater !! Flag if D2O (1) is used or H2O(0). type ( c_ptr ) :: gases !! Available gases. ! variables integer ( int32 ) :: i , j , ngas , n type ( iapws_g704_gas_t ), pointer :: f_gases (:) => null () f_gases => iapws_g704_gases ( heavywater ) ngas = size ( f_gases ) if ( allocated ( c_gases )) then deallocate ( c_gases ) endif allocate ( c_gases ( ngas )) if ( allocated ( char_pp )) then deallocate ( char_pp ) endif allocate ( char_pp ( ngas )) do i = 1 , ngas if ( allocated ( c_gases ( i )% gas )) then deallocate ( c_gases ( i )% gas ) endif n = len ( f_gases ( i )% gas ) allocate ( c_gases ( i )% gas ( n + 1 )) do j = 1 , n c_gases ( i )% gas ( j ) = f_gases ( i )% gas ( j : j ) enddo c_gases ( i )% gas ( n + 1 ) = c_null_char char_pp ( i )% p = c_loc ( c_gases ( i )% gas ) enddo gases = c_loc ( char_pp ) end function function iapws_g704_capi_gases2 ( heavywater ) bind ( C ) result ( gases ) !! Returns the available gases as a string. implicit none ! arguments integer ( c_int ), intent ( in ), value :: heavywater !! Flag if D2O (1) is used or H2O(0). type ( c_ptr ) :: gases !! Available gases. ! variables character ( len = :), pointer :: f_gases_str => null () f_gases_str => iapws_g704_gases2 ( heavywater ) if ( allocated ( c_gases_str )) then deallocate ( c_gases_str ) endif allocate ( character ( len = len ( f_gases_str )) :: c_gases_str ) c_gases_str = f_gases_str c_gases_str ( len ( f_gases_str ): len ( f_gases_str )) = c_null_char gases = c_loc ( c_gases_str ) end function end module","tags":"","loc":"sourcefile/iapws_g704_capi.f90.html"},{"title":"iapws_g704.f90 – iapws","text":"Contents Modules iapws_g704 Source Code iapws_g704.f90 Source Code module iapws_g704 !! Module for IAPWS G7-04 use iso_fortran_env use ieee_arithmetic implicit none private integer ( int32 ), parameter :: lengas = 5 integer ( int32 ), parameter :: ngas_H2O = 14 integer ( int32 ), parameter :: ngas_D2O = 7 type :: iapws_g704_gas_t !! Derived type containing a allocatable string for representing a gas. character ( len = :), allocatable :: gas !! Gas end type type ( iapws_g704_gas_t ), allocatable , target :: f_gases (:) character ( len = :), allocatable , target :: f_gases_str !> Absolute temperature in KELVIN real ( real64 ), parameter :: T_KELVIN = 27 3.15d0 !! Parameters from IAPWS G7-04 !> critical temperature of water in K real ( real64 ), parameter :: Tc1_H2O = 64 7.096d0 !> critical pressure of the water in K real ( real64 ), parameter :: pc1_H2O = 2 2.064d0 !> critical temperature of heavy water MPa real ( real64 ), parameter :: Tc1_D2O = 64 3.847d0 !> critical pressure of heavywater MPa real ( real64 ), parameter :: pc1_D2O = 2 1.671d0 !> solvent coefficient for kd in water real ( real64 ), parameter :: q_H2O = - 0.023767d0 !> solvent coefficient for kd in heavywater real ( real64 ), parameter :: q_D2O = - 0.024552d0 !! ABC coefficients for gases in water. type :: abc_t character ( len = lengas ) :: gas real ( real64 ) :: A real ( real64 ) :: B real ( real64 ) :: C end type type :: efgh_t character ( len = lengas ) :: gas real ( real64 ) :: E real ( real64 ) :: F real ( real64 ) :: G real ( real64 ) :: H end type !> ai and bi coefficients for water real ( real64 ), dimension ( 6 , 2 ), parameter :: aibi_H2O = reshape ([& - 7.85951783d0 , 1.84408259d0 , - 1 1.78664970d0 , 2 2.68074110d0 , - 1 5.96187190d0 , 1.80122502d0 ,& 1.000d0 , 1.500d0 , 3.000d0 , 3.500d0 , 4.000d0 , 7.500d0 ], [ 6 , 2 ]) !> ai and bi coefficients for heavywater real ( real64 ), dimension ( 5 , 2 ), parameter :: aibi_D2O = reshape ([& - 7.8966570d0 , 2 4.7330800d0 , - 2 7.8112800d0 , 9.3559130d0 , - 9.2200830d0 , & 1.00d0 , 1.89d0 , 2.00d0 , 3.00d0 , 3.60d0 ], [ 5 , 2 ]) !> ABC constants water. type ( abc_t ), dimension ( ngas_H2O ), parameter :: abc_H2O = & [ abc_t ( \"He\" , - 3.52839d0 , 7.12983d0 , 4.47770d0 ),& abc_t ( \"Ne\" , - 3.18301d0 , 5.31448d0 , 5.43774d0 ),& abc_t ( \"Ar\" , - 8.40954d0 , 4.29587d0 , 1 0.52779d0 ),& abc_t ( \"Kr\" , - 8.97358d0 , 3.61508d0 , 1 1.29963d0 ),& abc_t ( \"Xe\" , - 1 4.21635d0 , 4.00041d0 , 1 5.60999d0 ),& abc_t ( \"H2\" , - 4.73284d0 , 6.08954d0 , 6.06066d0 ),& abc_t ( \"N2\" , - 9.67578d0 , 4.72162d0 , 1 1.70585d0 ),& abc_t ( \"O2\" , - 9.44833d0 , 4.43822d0 , 1 1.42005d0 ),& abc_t ( \"CO\" , - 1 0.52862d0 , 5.13259d0 , 1 2.01421d0 ),& abc_t ( \"CO2\" , - 8.55445d0 , 4.01195d0 , 9.52345d0 ),& abc_t ( \"H2S\" , - 4.51499d0 , 5.23538d0 , 4.42126d0 ),& abc_t ( \"CH4\" , - 1 0.44708d0 , 4.66491d0 , 1 2.12986d0 ),& abc_t ( \"C2H6\" , - 1 9.67563d0 , 4.51222d0 , 2 0.62567d0 ),& abc_t ( \"SF6\" , - 1 6.56118d0 , 2.15289d0 , 2 0.35440d0 )] !> ABC constants for heavywater type ( abc_t ), dimension ( ngas_D2O ), parameter :: abc_D2O = & [ abc_t ( \"He\" , - 0.72643d0 , 7.02134d0 , 2.04433d0 ),& abc_t ( \"Ne\" , - 0.91999d0 , 5.65327d0 , 3.17247d0 ),& abc_t ( \"Ar\" , - 7.17725d0 , 4.48177d0 , 9.31509d0 ),& abc_t ( \"Kr\" , - 8.47059d0 , 3.91580d0 , 1 0.69433d0 ),& abc_t ( \"Xe\" , - 1 4.46485d0 , 4.42330d0 , 1 5.60919d0 ),& abc_t ( \"D2\" , - 5.33843d0 , 6.15723d0 , 6.53046d0 ),& abc_t ( \"CH4\" , - 1 0.01915d0 , 4.73368d0 , 1 1.75711d0 )] !> ci and di coefficients for water real ( real64 ), dimension ( 6 , 2 ), parameter :: cidi_H2O = reshape ([& 1.99274064d0 , 1.09965342d0 , - 0.510839303d0 , - 1.75493479d0 , - 4 5.5170352d0 , - 6.7469445d5 ,& 1.0d0 / 3.0d0 , 2.0d0 / 3.0d0 , 5.0d0 / 3.0d0 , 1 6.0d0 / 3.0d0 , 4 3.0d0 / 3.0d0 , 11 0.0d0 / 3.0d0 ], [ 6 , 2 ]) !> ci and di coefficients for heavywater real ( real64 ), dimension ( 4 , 2 ), parameter :: cidi_D2O = reshape ([& 2.7072d0 , 0.58662d0 , - 1.3069d0 , - 4 5.663d0 , & 0.374d0 , 1.45d0 , 2.6d0 , 1 2.3d0 ], [ 4 , 2 ]) !> EFGH constants for water type ( efgh_t ), dimension ( ngas_H2O ), parameter :: efgh_H2O = & [ efgh_t ( \"He\" , 226 7.4082d0 , - 2.9616d0 , - 3.2604d0 , 7.8819d0 ),& efgh_t ( \"Ne\" , 250 7.3022d0 , - 3 8.6955d0 , 11 0.3992d0 , - 7 1.9096d0 ),& efgh_t ( \"Ar\" , 231 0.5463d0 , - 4 6.7034d0 , 16 0.4066d0 , - 11 8.3043d0 ),& efgh_t ( \"Kr\" , 227 6.9722d0 , - 6 1.1494d0 , 21 4.0117d0 , - 15 9.0407d0 ),& efgh_t ( \"Xe\" , 202 2.8375d0 , 1 6.7913d0 , - 6 1.2401d0 , 4 1.9236d0 ),& efgh_t ( \"H2\" , 228 6.4159d0 , 1 1.3397d0 , - 7 0.7279d0 , 6 3.0631d0 ),& efgh_t ( \"N2\" , 238 8.8777d0 , - 1 4.9593d0 , 4 2.0179d0 , - 2 9.4396d0 ),& efgh_t ( \"O2\" , 230 5.0674d0 , - 1 1.3240d0 , 2 5.3224d0 , - 1 5.6449d0 ),& efgh_t ( \"CO\" , 234 6.2291d0 , - 5 7.6317d0 , 20 4.5324d0 , - 15 2.6377d0 ),& efgh_t ( \"CO2\" , 167 2.9376d0 , 2 8.1751d0 , - 11 2.4619d0 , 8 5.3807d0 ),& efgh_t ( \"H2S\" , 131 9.1205d0 , 1 4.1571d0 , - 4 6.8361d0 , 3 3.2266d0 ),& efgh_t ( \"CH4\" , 221 5.6977d0 , - 0.1089d0 , - 6.6240d0 , 4.6789d0 ),& efgh_t ( \"C2H6\" , 214 3.8121d0 , 6.8859d0 , - 1 2.6084d0 , 0.0d0 ),& efgh_t ( \"SF6\" , 287 1.7265d0 , - 6 6.7556d0 , 22 9.7191d0 , - 17 2.7400d0 )] !> EFGH constants for heavywater type ( efgh_t ), dimension ( ngas_D2O ), parameter :: efgh_D2O = & [ efgh_t ( \"He\" , 229 3.2474d0 , - 5 4.7707d0 , 19 4.2924d0 , - 14 2.1257 ), & efgh_t ( \"Ne\" , 243 9.6677d0 , - 9 3.4934d0 , 33 0.7783d0 , - 24 3.0100d0 ),& efgh_t ( \"Ar\" , 226 9.2352d0 , - 5 3.6321d0 , 19 1.8421d0 , - 14 3.7659d0 ),& efgh_t ( \"Kr\" , 225 0.3857d0 , - 4 2.0835d0 , 14 0.7656d0 , - 10 2.7592d0 ),& efgh_t ( \"Xe\" , 203 8.3656d0 , 6 8.1228d0 , - 27 1.3390d0 , 20 7.7984d0 ),& efgh_t ( \"D2\" , 214 1.3214d0 , - 1.9696d0 , 1.6136d0 , 0.0d0 ),& efgh_t ( \"CH4\" , 221 6.0181d0 , - 4 0.7666d0 , 15 2.5778d0 , - 11 7.7430d0 )] public :: iapws_g704_gas_t public :: iapws_g704_kh , iapws_g704_kd public :: iapws_g704_ngases public :: iapws_g704_gases , iapws_g704_gases2 contains !> @brief Find the index of the gas in the ABC table. !! @param[in] gas Gas. !! @param[in] abc ABC table. pure function findgas_abc ( gas , abc ) result ( value ) implicit none !! arguments character ( len =* ), intent ( in ) :: gas type ( abc_t ), dimension (:), intent ( in ) :: abc !! returns integer ( int32 ) :: value !! local variables integer ( int32 ) :: i value = 0 do i = 1 , size ( abc ) if ( trim ( gas ) . eq . abc ( i )% gas ) then value = i exit endif end do end function !> @brief Find the index of the gas in the ABC table. !! @param[in] gas Gas. !! @param[in] efgh ABC table. pure function findgas_efgh ( gas , efgh ) result ( value ) implicit none !! arguments character ( len =* ), intent ( in ) :: gas type ( efgh_t ), dimension (:), intent ( in ) :: efgh !! returns integer ( int32 ) :: value !! local variables integer ( int32 ) :: i value = 0 do i = 1 , size ( efgh ) if ( trim ( gas ) . eq . efgh ( i )% gas ) then value = i exit endif end do end function pure elemental function f_p1star_H2O ( T ) result ( value ) implicit none !! arguments real ( real64 ), intent ( in ) :: T !! return real ( real64 ) :: value !! variables real ( real64 ) :: Tr real ( real64 ) :: tau Tr = ( T + T_KELVIN ) / Tc1_H2O tau = 1 - Tr value = exp ( 1 / ( Tr ) * sum ( aibi_H2O (:, 1 ) * tau ** ( aibi_H2O (:, 2 )))) * pc1_H2O end function pure elemental function f_p1star_D2O ( T ) result ( value ) implicit none !! arguments real ( real64 ), intent ( in ) :: T !! return real ( real64 ) :: value !! variables real ( real64 ) :: Tr real ( real64 ) :: tau Tr = ( T + T_KELVIN ) / Tc1_D2O tau = 1 - Tr value = exp ( 1 / ( Tr ) * sum ( aibi_D2O (:, 1 ) * tau ** ( aibi_D2O (:, 2 )))) * pc1_D2O end function pure elemental function f_kh_p1star_H2O ( T , abc ) result ( value ) !! arguments real ( real64 ), intent ( in ) :: T type ( abc_t ), intent ( in ) :: abc !! return real ( real64 ) :: value !! variables real ( real64 ) :: Tr real ( real64 ) :: tau Tr = ( T + T_KELVIN ) / Tc1_H2O tau = 1 - Tr value = exp ( abc % A / Tr + abc % B * ( tau ** 0.355d0 ) / Tr + abc % C * exp ( tau ) * Tr ** ( - 0.41d0 )) end function pure elemental function f_kh_p1star_D2O ( T , abc ) result ( value ) !! arguments real ( real64 ), intent ( in ) :: T type ( abc_t ), intent ( in ) :: abc !! return real ( real64 ) :: value !! variables real ( real64 ) :: Tr real ( real64 ) :: tau Tr = ( T + T_KELVIN ) / Tc1_D2O tau = 1 - Tr value = exp ( abc % A / Tr + abc % B * ( tau ** 0.355d0 ) / Tr + abc % C * exp ( tau ) * Tr ** ( - 0.41d0 )) end function pure elemental function ft_H2O ( tau ) result ( value ) implicit none !! arguments real ( real64 ), intent ( in ) :: tau !! return real ( real64 ) :: value value = sum ( cidi_H2O (:, 1 ) * tau ** ( cidi_H2O (:, 2 ))) end function pure elemental function ft_D2O ( tau ) result ( value ) implicit none !! arguments real ( real64 ), intent ( in ) :: tau !! return real ( real64 ) :: value value = sum ( cidi_D2O (:, 1 ) * tau ** ( cidi_D2O (:, 2 ))) end function pure elemental function f_kh_H2O ( T , abc ) result ( value ) implicit none !! arguments real ( real64 ), intent ( in ) :: T type ( abc_t ), intent ( in ) :: abc !! returns real ( real64 ) :: value value = f_kh_p1star_H2O ( T , abc ) * f_p1star_H2O ( T ) end function pure elemental function f_kh_D2O ( T , abc ) result ( value ) implicit none !! arguments real ( real64 ), intent ( in ) :: T type ( abc_t ), intent ( in ) :: abc !! returns real ( real64 ) :: value value = f_kh_p1star_D2O ( T , abc ) * f_p1star_D2O ( T ) end function pure elemental function f_kd_H2O ( T , efgh ) result ( value ) implicit none !! arguments real ( real64 ), intent ( in ) :: T type ( efgh_t ), intent ( in ) :: efgh !! returns real ( real64 ) :: value !! local variables real ( real64 ) :: Tr real ( real64 ) :: tau real ( real64 ) :: p1 real ( real64 ) :: p2 real ( real64 ) :: p3 real ( real64 ) :: p4 Tr = ( T + T_KELVIN ) / Tc1_H2O tau = 1 - Tr p1 = q_H2O * efgh % F p2 = efgh % E / ( T + T_KELVIN ) * ft_H2O ( tau ) p3 = ( efgh % F + efgh % G * tau ** ( 2.0d0 / 3.0d0 ) + efgh % H * tau ) p4 = exp ( - T / 10 0.0d0 ) value = exp ( p1 + p2 + p3 * p4 ) end function pure elemental function f_kd_D2O ( T , efgh ) result ( value ) implicit none !! arguments real ( real64 ), intent ( in ) :: T type ( efgh_t ), intent ( in ) :: efgh !! returns real ( real64 ) :: value !! local variables real ( real64 ) :: Tr real ( real64 ) :: tau real ( real64 ) :: p1 real ( real64 ) :: p2 real ( real64 ) :: p3 real ( real64 ) :: p4 Tr = ( T + T_KELVIN ) / Tc1_D2O tau = 1 - Tr p1 = q_D2O * efgh % F p2 = efgh % E / ( T + T_KELVIN ) * ft_D2O ( tau ) p3 = ( efgh % F + efgh % G * tau ** ( 2.0d0 / 3.0d0 ) + efgh % H * tau ) p4 = exp ( - T / 10 0.0d0 ) value = exp ( p1 + p2 + p3 * p4 ) end function pure subroutine iapws_g704_kh ( T , gas , heavywater , k ) !! Compute the henry constant for a given temperature. implicit none ! arguments real ( real64 ), intent ( in ) :: T (:) !! Temperature in °C. character ( len =* ), intent ( in ) :: gas !! Gas. integer ( int32 ), intent ( in ) :: heavywater !! Flag if D2O (1) is used or H2O(0). real ( real64 ), intent ( out ) :: k (:) !! Henry constant. Filled with NaNs if gas not found. ! variables integer ( int32 ) :: i if ( heavywater > 0 ) then i = findgas_abc ( gas , abc_D2O ) if ( i == 0 ) then k = ieee_value ( 1.0d0 , ieee_quiet_nan ) else k = f_kh_D2O ( T , abc_D2O ( i )) endif else i = findgas_abc ( gas , abc_H2O ) if ( i == 0 ) then k = ieee_value ( 1.0d0 , ieee_quiet_nan ) else k = f_kh_H2O ( T , abc_H2O ( i )) endif endif end subroutine pure subroutine iapws_g704_kd ( T , gas , heavywater , k ) !! Compute the vapor-liquid constant for a given temperature. implicit none ! arguments real ( real64 ), intent ( in ) :: T (:) !! Temperature in °C. character ( len =* ), intent ( in ) :: gas !! Gas. integer ( int32 ), intent ( in ) :: heavywater !! Flag if D2O (1) is used or H2O(0). real ( real64 ), intent ( out ) :: k (:) !! Vapor-liquid constant. Filled with NaNs if gas not found. ! variables integer ( int32 ) :: i if ( heavywater > 0 ) then i = findgas_efgh ( gas , efgh_D2O ) if ( i == 0 ) then k = ieee_value ( 1.0d0 , ieee_quiet_nan ) else k = f_kd_D2O ( T , efgh_D2O ( i )) endif else i = findgas_efgh ( gas , efgh_H2O ) if ( i == 0 ) then k = ieee_value ( 1.0d0 , ieee_quiet_nan ) else k = f_kd_H2O ( T , efgh_H2O ( i )) endif endif end subroutine pure function iapws_g704_ngases ( heavywater ) result ( n ) !! Returns the number of gases. implicit none ! arguments integer ( int32 ), intent ( in ) :: heavywater !! Flag if D2O (1) is used or H2O(0). integer ( int32 ) :: n !! Number of gases. if ( heavywater > 0 ) then n = ngas_D2O else n = ngas_H2O endif end function function iapws_g704_gases ( heavywater ) result ( gases ) !! Returns the list of available gases. implicit none ! arguments integer ( int32 ), intent ( in ) :: heavywater !! Flag if D2O (1) is used or H2O(0). type ( iapws_g704_gas_t ), pointer :: gases (:) !! Available gases. ! variables integer ( int32 ) :: i , n if ( allocated ( f_gases )) then deallocate ( f_gases ) endif if ( heavywater > 0 ) then allocate ( f_gases ( ngas_D2O )) do i = 1 , ngas_D2O if ( allocated ( f_gases ( i )% gas )) then deallocate ( f_gases ( i )% gas ) endif n = len ( trim ( abc_D2O ( i )% gas )) allocate ( character ( len = n ) :: f_gases ( i )% gas ) f_gases ( i )% gas = trim ( abc_D2O ( i )% gas ) enddo else allocate ( f_gases ( ngas_H2O )) do i = 1 , ngas_H2O if ( allocated ( f_gases ( i )% gas )) then deallocate ( f_gases ( i )% gas ) endif n = len ( trim ( abc_H2O ( i )% gas )) allocate ( character ( len = n ) :: f_gases ( i )% gas ) f_gases ( i )% gas = trim ( abc_H2O ( i )% gas ) enddo endif gases => f_gases end function function iapws_g704_gases2 ( heavywater ) result ( gases ) !! Returns the available gases as a string. implicit none ! arguments integer ( int32 ), intent ( in ) :: heavywater !! Flag if D2O (1) is used or H2O(0). character ( len = :), pointer :: gases !! Available gases ! variables integer ( int32 ) :: i , j , k , ngas type ( iapws_g704_gas_t ), pointer :: f_gases (:) f_gases => iapws_g704_gases ( heavywater ) ngas = size ( f_gases ) k = 0 do i = 1 , ngas k = k + len ( f_gases ( i )% gas ) enddo if ( allocated ( f_gases_str )) then deallocate ( f_gases_str ) endif allocate ( character ( len = k + ngas ) :: f_gases_str ) i = 1 j = 1 k = 1 do i = 1 , ngas do j = 1 , len ( f_gases ( i )% gas ) f_gases_str ( k : k ) = f_gases ( i )% gas ( j : j ) k = k + 1 enddo f_gases_str ( k : k ) = \",\" k = k + 1 enddo f_gases_str ( len ( f_gases_str ): len ( f_gases_str )) = \"\" gases => f_gases_str end function end module","tags":"","loc":"sourcefile/iapws_g704.f90.html"}]}