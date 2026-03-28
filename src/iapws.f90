! NAME
!     iapws - library for light and heavy water properties according to IAPWS.
! 
! LIBRARY
!     iapws (-libiapws, -libiapws)
! 
! SYNOPSIS
!     use iapws
!     include "iapws.h"
!     import pyiapws
! 
! DESCRIPTION
!     Numerical implementation for reports:
!         o R2-83
!             o [x] Tc in H2O and D2O
!             o [x] pc in H2O and D2O
!             o [x] rhoc in H2O and D2O
!         o G7-04
!             o [x] kH
!             o [x] kD
!         o R7-97
!             o [x] Region 1
!             o [ ] Region 2
!             o [ ] Region 3
!             o [x] Region 4
!             o [ ] Region 5
!         o R11-24:
!             o [x] Kw
! 
!     Fortran API:
!         o function get_version()result(fptr)  Get the version.
!                                               Deprecated. It will be removed in the next major release.
!                                               Use version() instead.
!              o character(len=:), pointer :: fptr    Fortran pointer to a string indicating the version..
!         o function capi_get_version()bind(c, name='iapws_get_version')result(cptr)  C API.
!              o type(c_ptr) :: cptr    C pointer to a string indicating the version.
!         o function version()result(fptr)  Get the version.
!              o character(len=:), pointer :: fptr    Pointer to a string (=>version).
!         o function capi_version()bind(C,name="iapws_version")result(cptr)  C API - Get the version
!              o type(c_ptr) :: cptr    C pointer to a string indicating the version.
! 
!     C API:
!         o char* iapws_get_version(void)
!         o char* iapws_version(void)
!         o void iapws_g704_kh(double *T, char *gas, int heavywater, double *k, int size_gas, size_t size_T)
!         o void iapws_g704_kd(double *T, char *gas, int heavywater, double *k, int size_gas, size_t size_T)
!         o int iapws_g704_ngases(int heavywater)
!         o char **iapws_g704_gases(int heavywater)
!         o char *iapws_g704_gases2(int heavywater)
!         o void iapws_r797_psat(size_t N, double *Ts, double *ps)
!         o void iapws_r797_Tsat(size_t N, double *ps, double *Ts)
!         o void iapws_r797_wp(double *p, double *T, char *prop, double *res, size_t N, size_t len)
!         o void iapws_r797_wr(double *p, double *T, int *res, size_t N)
!         o void iapws_r797_wph(double *p, double *T, char *res, size_t N)
!         o void iapws_r1124_Kw(size_t N, double *T, double *rhow, double *k)
! 
!     Python API:
!         o kh(T: np.ndarray, gas: str, heavywater: bool=False)->Union[np.ndarray, float]
!         o kd(T: np.ndarray, gas: str, heavywater: bool=False)->Union[np.ndarray, float]
!         o ngases(heavywater:bool=False)->int
!         o gases(heavywater: bool=False)->List[str]
!         o gases2(heavywater: bool=False)->str
!         o psat(Ts)->Union[np.ndarray, float]
!         o Tsat(ps)->Union[np.ndarray, float]
!         o wp(p, T, prop)->Union[np.ndarray, float]
!         o wr(p, T)->Union[np.ndarray, float]
!         o wph(p, T)->Union[np.ndarray, str]
!         o Kw(T: np.ndarray, rhow: np.ndarray)->Union[np.ndarray, float]
! 
! NOTES
!     To use iapws within your fpm project, add the following to your fpm.toml file:
! 
!         [dependencies]
!         iapws = { git="https://github.com/MilanSkocic/iapws.git" }
! 
!     o dp stands for double precision and it is an alias to real64
!     from the iso_fortran_env module.
!     o l => liquid
!     o v => vapor
!     o c => super critical
!     o s => saturation
!     o n => unknown
! 
! EXAMPLE
! 
!     Example in Fortran
! 
!         program example_in_f
!         use iapws__common, only: dp, int32
!         use iapws
!         implicit none(type,external)
! 
!         integer(int32) :: i, ngas
!         real(dp) :: T(1), kh_res(1), kd_res(1), wp_res(1), p(1)
!         real(dp) :: Ts(7), ps(7)
!         real(dp) :: x(3), y(3)
!         integer(int32) :: r(3)
!         character(len=1) :: s(3)
!         character(len=2) :: gas = "O2"
!         integer(int32) :: heavywater = 0
!         type(gas_type), pointer :: gases_list(:)
!         character(len=:), pointer :: gases_str
! 
!         print *, '########################## IAPWS VERSION ##########################'
!         print *, "version ", version()
! 
!         print *, '########################## IAPWS R2-83 ##########################'
!         print "(a, f10.3, a)", "Tc in h2o=", Tc_H2O, " k"
!         print "(a, f10.3, a)", "pc in h2o=", pc_H2O, " mpa"
!         print "(a, f10.3, a)", "rhoc in h2o=", rhoc_H2O, " kg/m3"
! 
!         print "(a, f10.3, a)", "Tc in D2O=", Tc_D2O, " k"
!         print "(a, f10.3, a)", "pc in D2O=", pc_D2O, " mpa"
!         print "(a, f10.3, a)", "rhoc in D2O=", rhoc_D2O, " kg/m3"
!         print *, ''
! 
!         print *, '########################## IAPWS G7-04 ##########################'
!         ! Compute kh and kd in H2O
!         T(1) = 25.0_dp + 273.15_dp
!         call kh(T, gas, heavywater, kh_res)
!         print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F10.4)", "Gas=", gas, "T=", T, "K", "kh=", kh_res
! 
!         call kd(T, gas, heavywater, kd_res)
!         print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F15.4)", "Gas=", gas, "T=", T, "K", "kh=", kd_res
! 
!         ! Get and print available gases
!         heavywater = 0
!         ngas = ngases(heavywater)
!         gases_list => null()
!         gases_list => gases(heavywater)
!         gases_str => gases2(heavywater)
!         print *, "Gases in H2O: ", ngas
!         print *, gases_str
!         do i=1, ngas
!         print *, gases_list(i)%gas
!         enddo
! 
!         heavywater = 1
!         ngas = ngases(heavywater)
!         gases_list => null()
!         gases_list => gases(heavywater)
!         gases_str => gases2(heavywater)
!         print *, "Gases in D2O: ", ngas
!         print *, gases_str
!         do i=1, ngas
!         print *, gases_list(i)%gas
!         enddo
! 
!         print *, '########################## IAPWS R7-97 ##########################'
!         ! Compute ps from Ts.
!         Ts(:) = [-1.0_dp, 25.0_dp, 100.0_dp, 200.0_dp, 300.0_dp, 360.0_dp, 374.0_dp]
!         Ts(:) = Ts(:) + 273.15_dp
!         call psat(Ts, ps)
! 
!         do i=1, size(Ts)
!         print "(SP, F23.3, A3, 4X, F23.3, A3)", Ts(i), "K", ps(i), "MPa"
!         end do
! 
!         ! Compute Ts from ps
!         call Tsat(ps, Ts)
!         do i=1, size(Ts)
!         print "(SP, F23.3, A3, 4X, F23.3, A3)", Ts(i), "K", ps(i), "MPa"
!         end do
! 
!         ! Compute water properties at 280°C/8 Mpa
!         p(1) = 8.0_dp
!         T(1) = 273.15_dp + 280.0_dp
!         call wp(p, T, "v", wp_res)
!         print "(A5, F23.16, X, A)", "v(8MPa,280°C)=", wp_res(1)*1000.0_dp, "L/kg"
! 
!         ! Compute region and phase
!         x = [8.0_dp, 4.0_dp, 6.0_dp ]
!         y = [553.15_dp, 1200.0_dp, 2000.0_dp]
!         call wr(x, y, r)
!         call wph(x, y, s)
!         print *, r
!         print *, s
! 
!         end program example_in_f
! 
!     Example in C
! 
!         #include <string.h>
!         #include <stdio.h>
!         #include "iapws.h"
! 
!         int main(void){
!         double T = 25.0 + 273.15; /* in C*/
!         double p; /* p in Mpa */
!         char *gas = "O2";
!         double kh, kd, wp_res;
!         char **gases_list;
!         char *gases_str;
!         int ngas;
!         int i;
!         int heavywater = 0;
!         double x[3]= {8.0, 4.0, 6.0 };
!         double y[3] = {553.15, 1200.0, 2000.0};
!         int r[3];
!         char s[3];
! 
!         printf("%s\n", "########################## IAPWS VERSION ##########################");
!         printf("version %s\n", iapws_version());
! 
!         printf("%s\n", "########################## IAPWS R2-83 ##########################");
!         printf("%s %10.3f %s\n", "Tc in H2O", iapws_r283_Tc_H2O, "K");
!         printf("%s %10.3f %s\n", "pc in H2O", iapws_r283_pc_H2O, "MPa");
!         printf("%s %10.3f %s\n", "rhoc in H2O", iapws_r283_rhoc_H2O, "kg/m3");
! 
!         printf("%s %10.3f %s\n", "Tc in D2O", iapws_r283_Tc_D2O, "K");
!         printf("%s %10.3f %s\n", "pc in D2O", iapws_r283_pc_D2O, "MPa");
!         printf("%s %10.3f %s\n", "rhoc in D2O", iapws_r283_rhoc_D2O, "kg/m3");
! 
!         printf("\n");
! 
! 
!         printf("%s\n", "########################## IAPWS G7-04 ##########################");
!         /* Compute kh and kd in H2O*/
!         iapws_g704_kh(&T, gas, heavywater, &kh, strlen(gas), 1);
!         printf("Gas=%s\tT=%fK\tkh=%+10.4f\n", gas, T, kh);
! 
!         iapws_g704_kd(&T, gas, heavywater, &kd, strlen(gas), 1);
!         printf("Gas=%s\tT=%fK\tkd=%+15.4f\n", gas, T, kd);
! 
!         /* Get and print the available gases */
!         ngas = iapws_g704_ngases(heavywater);
!         gases_list = iapws_g704_gases(heavywater);
!         gases_str = iapws_g704_gases2(heavywater);
!         printf("Gases in H2O: %d\n", ngas);
!         printf("%s\n", gases_str);
!         for(i=0; i<ngas; i++){
!             printf("%s\n", gases_list[i]);
!         }
! 
!         heavywater = 1;
!         ngas = iapws_g704_ngases(heavywater);
!         gases_list = iapws_g704_gases(heavywater);
!         gases_str = iapws_g704_gases2(heavywater);
!         printf("Gases in D2O: %d\n", ngas);
!         printf("%s\n", gases_str);
!         for(i=0; i<ngas; i++){
!             printf("%s\n", gases_list[i]);
!         }
! 
!         printf("%s\n", "########################## IAPWS R7-97 ##########################");
!         double Ts[7] =  {-1.0, 25.0, 100.0, 200.0, 300.0, 360.0, 374.0};
!         double ps[7] = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
!         for(i=0; i<7; i++){
!             Ts[i] = Ts[i] + 273.15;
!         }
!         iapws_r797_psat(7, Ts, ps);
! 
!         for(i=0; i<7; i++){
!             printf("%+23.3f %s %+23.3f %s\n", Ts[i], "K", ps[i], "MPa");
!         }
! 
!         iapws_r797_Tsat(7, ps, Ts);
!         for(i=0; i<7; i++){
!             printf("%+23.3f %s %+23.3f %s\n", Ts[i], "K", ps[i], "MPa");
!         }
! 
!         T = 273.15 + 280.0;
!         p = 8.0;
!         iapws_r797_wp(&p, &T, "v", &wp_res, 1, 1);
!         printf("v(8MPa,280°C) = %+23.16f L/kg\n", wp_res * 1000.0);
! 
!         iapws_r797_wr(x, y, r, 3);
!         iapws_r797_wph(x, y, s, 3);
!         for(i=0; i<3; i++){
!             printf("%i", r[i]);
!         }
!         printf("\n");
!         for(i=0; i<3; i++){
!             printf("%c", s[i]);
!         }
!         printf("\n");
! 
!         return 0;
!         }
! 
!     Example in Python
! 
!         r"""Example in python"""
!         import sys
!         sys.path.insert(0, "../py/src/")
!         import array
!         import numpy as np
!         import matplotlib.pyplot as plt
!         import pyiapws
! 
!         print("########################## IAPWS VERSION ##########################")
!         print(pyiapws.__version__)
! 
!         print("########################## IAPWS R2-83 ##########################")
!         print("Tc in H2O", pyiapws.Tc_H2O, "K")
!         print("pc in H2O", pyiapws.pc_H2O, "MPa")
!         print("rhoc in H2O", pyiapws.rhoc_H2O, "kg/m3")
! 
!         print("Tc in D2O", pyiapws.Tc_D2O, "K")
!         print("pc in D2O", pyiapws.pc_D2O, "MPa")
!         print("rhoc in D2O", pyiapws.rhoc_D2O, "kg/m3")
! 
!         print("")
! 
!         print("########################## IAPWS G7-04 ##########################")
!         gas  = "O2"
!         T = array.array("d", (25.0+273.15,))
! 
!         # Compute kh and kd in H2O
!         heavywater = False
!         k = pyiapws.kh(T, "O2", heavywater)
!         print(f"Gas={gas}\tT={T[0]}K\tkh={k[0]:+10.4f}\n")
! 
!         k = pyiapws.kd(T, "O2", heavywater)
!         print(f"Gas={gas}\tT={T[0]}K\tkd={k[0]:+10.4f}\n")
! 
!         # Get and print the available gases
!         heavywater = False
!         gases_list = pyiapws.gases(heavywater)
!         gases_str = pyiapws.gases2(heavywater)
!         ngas = pyiapws.ngases(heavywater)
!         print(f"Gases in H2O: {ngas:}")
!         print(gases_str)
!         for gas in gases_list:
!             print(gas)
! 
!         heavywater = True
!         gases_list = pyiapws.gases(heavywater)
!         gases_str = pyiapws.gases2(heavywater)
!         ngas = pyiapws.ngases(heavywater)
!         print(f"Gases in D2O: {ngas:}")
!         print(gases_str)
!         for gas in gases_list:
!             print(gas)
! 
!         style = {"marker":".", "ls":"", "ms":2}
!         T_KELVIN = 273.15
!         T = np.linspace(0.0, 360.0, 1000) + 273.15
! 
!         solvent = {True: "D2O", False: "H2O"}
! 
!         print("Generating plot for kh")
!         kname = "kh"
!         for HEAVYWATER in (False, True):
!             print(solvent[HEAVYWATER])
!             fig = plt.figure()
!             ax = fig.add_subplot()
!             ax.grid(visible=True, ls=':')
!             ax.set_xlabel("T /°K")
!             ax.set_ylabel("ln (kh/1GPa)")
!             gases = pyiapws.gases(HEAVYWATER)
!             for gas in gases:
!                 k = pyiapws.kh(T, gas, HEAVYWATER) / 1000.0
!                 ln_k = np.log(k)
!                 ax.plot(T, ln_k, label=gas, **style)
!             ax.legend(ncol=3)
!             fig.savefig(f"../media/g704-{kname:s}_{solvent[HEAVYWATER]}.png", dpi=100, format="png")
! 
!         print("Generating plot for kd")
!         kname = "kd"
!         for HEAVYWATER in (False, True):
!             print(solvent[HEAVYWATER])
!             fig = plt.figure()
!             ax = fig.add_subplot()
!             ax.grid(visible=True, ls=':')
!             ax.set_xlabel("T /°K")
!             ax.set_ylabel("ln kd")
!             gases = pyiapws.gases(HEAVYWATER)
!             for gas in gases:
!                 k = pyiapws.kd(T, gas, HEAVYWATER)
!                 ln_k = np.log(k)
!                 ax.plot(T, ln_k, label=gas, **style)
!             ax.legend(ncol=3)
!             fig.savefig(f"../media/g704-{kname:s}_{solvent[HEAVYWATER]}.png", dpi=100, format="png")
! 
! 
! 
!         print("########################## IAPWS R7-97 ##########################")
!         Ts = np.asarray([-1.0, 25.0, 100.0, 200.0, 300.0, 360.0, 374.0])
!         Ts = Ts + 273.15
! 
! 
!         ps = pyiapws.psat(Ts)
!         for i in range(Ts.size):
!             print(f"{Ts[i]:23.3f} K {ps[i]:23.3f} MPa.")
! 
!         Ts = pyiapws.Tsat(ps)
!         for i in range(Ts.size):
!             print(f"{Ts[i]:23.3f} K {ps[i]:23.3f} MPa.")
! 
!         fig = plt.figure()
!         ax = fig.add_subplot()
!         ax.grid(visible=True, ls=':')
!         ax.set_xlabel("Ts /K")
!         ax.set_ylabel("ps /MPa")
!         Ts = np.linspace(0.0, 370.0, 500)
!         Ts = Ts + 273.15
! 
!         ps = pyiapws.psat(Ts)
!         ax.plot(Ts, ps, "r-", label="ps(Ts)")
! 
!         Ts = pyiapws.Tsat(ps)
!         ax.plot(Ts, ps, "b--", label="Ts(ps)")
! 
!         ax.legend()
!         fig.savefig(f"../media/r797-r4.png", dpi=100, format="png")
! 
! 
!         T = 280.0 + 273.15
!         p = 8.0
!         res = pyiapws.wp(p, T, "v")*1000.0
!         print(f"v(8MPa,280°C) = {res:+23.16f} L/kg)")
! 
!         x = np.asarray([8.0, 4.0, 6.0 ])
!         y = np.asarray([553.15, 1200.0, 2000.0])
!         r=pyiapws.wr(x, y)
!         s=pyiapws.wph(x, y)
!         print(r)
!         print(s)
! 
! 
!         plt.show()
! 
! 
! SEE ALSO
!     codata(3), ciaaw(3)
module iapws
!! Main module for the IAPWS library.
use iapws__r283, only: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O
use iapws__r283, only: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O
use iapws__capi
use iapws__api

character(len=*), parameter, private :: v = '0.7.1'
character(len=:), allocatable, target :: vf
character(len=:), allocatable, target :: vc


!=======================================================================
! PUBLIC
!=======================================================================
public :: get_version, capi_get_version
public :: version, capi_version
public :: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O
public :: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O
!=======================================================================

contains
!=======================================================================
! GET_VERSION() - DEPRECATED
!=======================================================================
function get_version()result(fptr)
!! Get the version.
!! Deprecated. It will be removed in the next major release.
!! Use version() instead.
implicit none
character(len=:), pointer :: fptr  !! Fortran pointer to a string indicating the version..
fptr => version()
end function get_version
!-----------------------------------------------------------------------
function capi_get_version()bind(c, name='iapws_get_version')result(cptr)
!! C API.
type(c_ptr) :: cptr    !! C pointer to a string indicating the version.
cptr = capi_version()
end function capi_get_version
!=======================================================================


!=======================================================================
! VERSION()
!=======================================================================
function version()result(fptr)
!! Get the version.
character(len=:), pointer :: fptr !! Pointer to a string (=>version).
if(allocated(vf))then
    deallocate(vf)
endif
allocate(character(len=len(v)) :: vf)
vf = v
fptr => vf
end function version
!-----------------------------------------------------------------------
function capi_version()bind(C,name="iapws_version")result(cptr)
!! C API - Get the version
type(c_ptr) :: cptr !! C pointer to a string indicating the version.
character(len=:), pointer :: fptr
fptr => version()
if(allocated(vc))then
    deallocate(vc)
endif
allocate(character(len=len(fptr)+1) :: vc)
vc = fptr // c_null_char
cptr = c_loc(vc)
end function capi_version
!=======================================================================
end module
