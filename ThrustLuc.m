clear all;
close all;
clc;

A_measurementref = [1157 5010 249 1.7 798 813 360 12.5; 
1297 5020 221 2.4 673 682 412 10.5;
1426 5020 192 3.6 561 579 447 8.8;
1564 5030 163 5.4 463 484 478 7.2;
1787 5020 130 8.7 443 467 532 6;
1920 5110 118 10.6 474 499 570 5.2];  

A_measurementflight = [1130 5030 251 1.6 770 806 367 10.2; 
1258 5030 221 2.4 638 670 422 7.8; 
1398 5020 190 3.7 533 579 456 5;
1530 5040 161 5.6 444 488 492 4; 
1664 5040 134 8.5 420 450 521 2.2; 
1763 5030 121 10.4 420 450 545 1.5];

Hpf        = A_measurementflight(:,2)*0.3048; %m
Machf      = M(A_measurementflight);
fuelleftf  = A_measurementflight(:,5)*0.000125998; %kg/s 
fuelrightf = A_measurementflight(:,6)*0.000125998;%kg/s
Delta_Tf   =  A_measurementflight(:,8) - 15;    %degrees

Hpr        = A_measurementref(:,2)*0.3048; %m
Machr      = M(A_measurementref);
fuelleftr  = A_measurementref(:,5)*0.000125998; %kg/s 
fuelrightr = A_measurementref(:,6)*0.000125998;%kg/s
Delta_Tr   =  A_measurementref(:,8) - 15;    %degrees

for i = 1:length(A_measurementref(:,1))
A = Thrustcalc(Hpr(i),Machr(i),Delta_Tr(i),fuelleftr(i),fuelrightr(i));
Th(i,1) = A(1,1)+A(1,2);
end
function [W_kg] = W_loc(N_m,pounds_ZFM,pounds_FuelStart,A_measurement)
F_used = A_measurement(N_m,7);                    
W_lbm = pounds_ZFM + pounds_FuelStart - F_used;
W_kg = W_lbm*0.453592;
end

function [M_TAS] = M(A_measurement)
M_ans = zeros(length(A_measurement(:,1)),1);
%V_conv = 
% IAS2CAS = griddedInterpolant(V_conv(:,1),V_conv(:,2));
for i = 1:length(A_measurement(:,1))
    gamma = 1.4;                 % constant
    p0 = 101325;                % pressure at sea level [Pa]
    rho0 = 1.2250;              % air density at sea level [kg/m^3] 
    lambda = -0.0065;           % temperature gradient in ISA [K/m]
    T0 = 288.15;                % temperature at sea level in ISA [K]
    R = 287.05;                 % specific gas constant [m^2/sec^2K]
    g0 = 9.81;                  % [m/sec^2] (gravity constant)
    S = 30.00;                  % wing area [m^2]
    V_cas = (A_measurement(i,3)-2)*0.514444;        % calibrated airspeed [m/s]
    p = p0*(1+(lambda*(A_measurement(i,2)*0.3048))/T0)^(-g0/(lambda*R));
    Ms1 = 1 + ((gamma-1)/(2*gamma))*(rho0/p0)*(V_cas)^2; 
    Ms2 = Ms1^(gamma/(gamma-1));
    Ms3 = Ms2 - 1;
    Ms4 = 1 + (p0/p)*Ms3;
    Ms5 = Ms4^((gamma-1)/gamma);
    Ms6 = Ms5 - 1;
    Ms7 = (2/(gamma-1))*Ms6;
    M = sqrt(Ms7);
    M_ans(i,1) = M;
end
M_TAS = M_ans;
end

function[Thrustlr] = Thrustcalc(Hp,Mach,Delta_T,fuelleft,fuelright)
%Hp [m],Mach [-],Delta_T[deg],fuelleft[kg/s],fuelright[kg/s]
%writing to file
array= [Hp, Mach,Delta_T,fuelleft,fuelright];
fileID = fopen('matlab.dat','w');
for i = 1:1:length(array)
fprintf(fileID,"%d\n",array(i));
end
fclose(fileID);


system('thrust.exe &');

%output
load("thrust.dat");
Thrustlr = thrust;
end