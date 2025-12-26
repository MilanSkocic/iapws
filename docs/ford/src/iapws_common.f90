module iapws__common
    !! Common parameters
    use stdlib_kinds, only: int64, dp, int32, sp
    use stdlib_optval, only: optval
    use ieee_arithmetic, only: ieee_quiet_nan, ieee_value
    private

    public :: optval
    public :: sp, dp, int32, int64
    public :: ieee_value, ieee_quiet_nan

end module
