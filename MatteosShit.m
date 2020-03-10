%From V_c to V_e


clear all;
close all;
clc;

load('matlab.mat')

%Constants:
run("Cit_par.m");


p0 = 101325;
gamma = 1.4;

alt = flightdata.Dadc1_alt.data;
hp = alt.*0.3048;
cas = flightdata.Dadc1_cas.data;
V_c = cas.*0.514444;
sat = flightdata.Dadc1_sat.data;
Tm = sat + 273.15;

%P
p = p0* ( (1 + ((lambda*hp)/Temp0)).^(-(g/(lambda*R))));
%M
%M = sqrt(    (2/(gamma-1)) * ((1+(p0/p)*((1+((gamma-1)/(2*gamma))*(rho0/p0)*V_c.^2).^(gamma/(gamma-1))-1)).^(((gamma-1)/gamma) -1)   ));
%Redo M
M025 = 1 + ((gamma-1)/2*gamma) * (rho0/p0) * V_c.^2; 
M05 = M025.^(gamma/(gamma-1));
M1 = M05 - 1;
M2 = 1 + (p0./p).*M1; % HERE SOMETHIMG GOES WRONG
M3 = M2.^((gamma-1)/gamma);
M4 = M3 - 1 ;
M5 = (2/(gamma-1))*M4 ;
M6 = sqrt(M5);
%T 
T = Tm./(1+((gamma-1)/2).*M6.^2);
%a
a = sqrt( gamma*R*T);
%V_t
V_t = M6.*a;
%rho --> from perfect gas law
rhoreduction1 = R .* T;
rhoreduction2 = p.* (1./rhoreduction1);
%V_e
V_e = V_t .* sqrt((rhoreduction2./rho0));





