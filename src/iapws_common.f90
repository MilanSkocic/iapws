module iapws__common
!! Common parameters
use stdlib_kinds, only: int64, dp, int32, sp
use stdlib_optval, only: optval
use, intrinsic :: ieee_arithmetic, only: ieee_quiet_nan, ieee_value
use, intrinsic :: iso_c_binding, only: c_double, c_int, c_ptr, c_f_pointer, &
                  c_char, c_size_t, c_null_char, c_loc
implicit none(type,external)
public

real(dp), parameter ::  T_KELVIN = 273.15_dp !! Absolute temperature in KELVIN 

end module iapws__common
