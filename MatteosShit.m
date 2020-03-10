%From V_c to V_e


clear all;
close all;
clc;

load('matlab.mat')

%Constants:
run("Cit_par.m");

p = 1
p0 = 1
gamma = 1.4
hp = 1
g0 = 1
cas = flightdata.Dadc1_cas.data
V_c = cas
Tm = 1

%P
p = p0* ( (1 + ((lambda*hp)/Temp0))^(-(g0/(lambda*R))))
%M
M = sqrt(    (2/(gamma-1)) * ((1+(p0/p)*((1+((gamma-1)/(2*gamma))*(rho0/p0)*V_c^2)^(gamma/(gamma-1))-1))^(((gamma-1)/gamma) -1)   )
%T 
T = Tm/(1+((gamma-1)/2)*M^2)
%a
a = sqrt( gamma*R*T)
%V_t
V_t = M*a
%V_e
V_e = V_t * sqrt((rho/rho0))






